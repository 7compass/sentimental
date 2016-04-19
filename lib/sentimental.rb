class Sentimental
  attr_accessor :threshold, :word_scores, :neutral_regexps, :ngrams

  def initialize(threshold: 0, word_scores: nil, neutral_regexps: [], ngrams: 1)
    if ngrams >= 1
      @ngrams = ngrams.to_i
    else
      @ngrams = 1
    end
    @word_scores = word_scores || {}
    @word_scores.default = 0.0
    @threshold = threshold
    @neutral_regexps = neutral_regexps
  end

  def score(string)
    return 0 if neutral_regexps.any? {|regexp| string =~ regexp}

    extract_words_with_n_grams(string).inject(0) do |score, token| 
      score += word_scores[token]
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
    ['sentiwords', 'sentislang'].each do |filename|
      load_from(File.dirname(__FILE__) + "/../data/#{filename}.txt")
    end
  end

  def load_from(filename)
    File.open(filename) do |file|
      file.each_line do |line|
        parsed_line = line.chomp.scan(/^([^\s]+)\s+(.+)/).first
        sentiscore = parsed_line[0]
        text = parsed_line[1]
        word_scores[text] = sentiscore.to_f
      end
    end
  end
  
  alias_method :load_senti_file, :load_from

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
    return [words.join(" ")] if words.size == max_size
    tail = words.last(words.size - 1)
    
    [words.first(max_size).join(" ")] + ngramify(tail, max_size)
  end
end
