class Sentimental
  attr_accessor :threshold, :word_scores, :neutral_regexps

  def initialize(threshold: 0, word_scores: nil, neutral_regexps: [])
    @word_scores = Hash.new(0.0) || word_scores
    @threshold = threshold
    @neutral_regexps = neutral_regexps
  end

  def score(string)
    return 0 if neutral_regexps.any? {|regexp| string =~ regexp}

    extract_words(string).inject(0) do |score, token| 
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

  def load_defaults
    ['sentiwords', 'sentislang'].each do |filename|
      load_senti_file(File.dirname(__FILE__) + "/../data/#{filename}.txt")
    end
  end

  def load_senti_file(filename)
    File.open(filename) do |file|
      file.each_line do |line|
        parsed_line = line.chomp.split(/\s+/)
        sentiscore = parsed_line[0]
        text = parsed_line[1]
        word_scores[text] = sentiscore.to_f
      end
    end
  end

  private

  def extract_words(string)
    string.to_s.downcase.scan(/([\w']+|\S{2,})/).flatten
  end
end
