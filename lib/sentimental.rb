require_relative 'file_reader'

class Sentimental
  include FileReader

  attr_accessor :threshold, :word_scores, :neutral_regexps, :ngrams

  def initialize(threshold: 0, word_scores: nil, neutral_regexps: [], ngrams: 1)
    @ngrams = ngrams.to_i.abs if ngrams.to_i >= 1
    @word_scores = word_scores || {}
    @word_scores.default = 0.0
    @threshold = threshold
    @neutral_regexps = neutral_regexps
  end

  def score(string)
    return 0 if neutral_regexps.any? { |regexp| string =~ regexp }

    extract_words_with_n_grams(string).inject(0) do |score, token|
      score + word_scores[token]
    end
  end

  def sentiment(string)
    score = score(string)

    if score < (-1 * threshold)
      :negative
    elsif score > threshold
      :positive
    else
      :neutral
    end
  end

  def classify(string)
    sentiment(string) == :positive
  end

  def load_defaults
    %w(slang en_words).each do |filename|
      load_from_json(File.dirname(__FILE__) + "/../data/#{filename}.json")
    end
  end

  def load_from(filename)
    word_scores.merge!(hash_from_txt(filename))
  end

  def load_from_json(filename)
    word_scores.merge!(hash_from_json(filename))
  end

  alias load_senti_file load_from
  alias load_senti_json load_from_json

  private

  def extract_words(string)
    string.to_s.downcase.scan(/([\w']+|\S{2,})/).flatten
  end

  def extract_words_with_n_grams(string)
    words = extract_words(string)
    (1..ngrams).to_a.map do |ngram_size|
      ngramify(words, ngram_size)
    end.flatten
  end

  def ngramify(words, max_size)
    return [words.join(' ')] if words.size <= max_size
    tail = words.last(words.size - 1)

    [words.first(max_size).join(' ')] + ngramify(tail, max_size)
  end
end
