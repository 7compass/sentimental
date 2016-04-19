class Sentimental
  attr_accessor :threshold, :word_scores, :neutral_regexps

  def initialize(threshold: 0, word_scores: nil, neutral_regexps: [])
    @word_scores = word_scores || Hash.new(0.0)
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
        parsed_line = line.chomp.split(/\s+/)
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
end
