require_relative "../lib/sentimental"

describe Sentimental do

  before :each do
    analyzer.load_defaults
  end

  let(:analyzer) { Sentimental.new(threshold: 0.1) }

  describe "#sentiment" do
    it "returns :positive when the score > threshold" do
      expect(analyzer.sentiment("I love ruby <3")).to be :positive
    end

    it "returns :negative when the score < -threshold" do
      expect(analyzer.sentiment("I hate javascript")).to be :negative
    end

    it "returns :positive when -threshold < score < threshold" do
      expect(analyzer.sentiment("je en sais pas")).to be :neutral
    end
  end

  describe "#classify" do
    it "is true when in the class" do
      expect(analyzer.classify("I love ruby")).to be_truthy
    end

    it "is false otherwise" do
      expect(analyzer.classify("je ne sais pas")).to be_falsy
      expect(analyzer.classify("i hate java")).to be_falsy
    end
  end

  describe "initialization" do
    subject do
      Sentimental.new(
        threshold: 0.2,
        word_scores: {"non" => -1.0},
        neutral_regexps: [/.*/],
      )
    end

    it "takes multiple init params" do
      expect(subject.threshold).to eq 0.2
      expect(subject.word_scores["non"]).to eq -1.0
      expect(subject.neutral_regexps).to include /.*/
    end
  end

  describe "neutral regexp" do
    context "when there is some neutral regexp" do
      let(:text_neutral) {"Do you love ruby?"}
      let(:text) {"I love ruby"}

      before do
        analyzer.neutral_regexps << /\?\s*$/
      end

      it "scores it to 0" do
        expect(analyzer.score(text_neutral)).to eq 0
        expect(analyzer.score(text)).not_to eq 0
      end
    end
  end

  describe "n-grams" do
    let(:word_scores) { nil }
    subject do
      Sentimental.new(word_scores: word_scores, ngrams: 3)
    end

    it "is initialized by ngrams param" do
      expect(subject.ngrams).to eq 3
    end
    
    context "there is n-grams in the dictionary" do
      let(:word_scores) {{"happy hour" => 1.0, "not happy hour" => -5.0}}
      let(:text) { "why not happy hour, but happy so hour?" }

      it "update scores regarding to n-grams" do
        expect(subject.score(text)).to eq -4
      end
    end

    context "there's n-grams longer than specified in dictionary" do
      let(:word_scores) {{"happy hour" => 1.0, "not so happy hour" => -5.0}}
      let(:text) { "why not so happy hour ?" }

      it "ignores the lines" do
        expect(subject.score(text)).to eq 1
      end
    end
  end

  describe "scoring in a normal context" do
    subject do
      analyzer.score(text)
    end

    context "when the text is postive" do
      let(:text) {'I love ruby'}

      it 'returns a positive score' do
        expect(subject).to be > 0
      end
    end

    context "when the text is neutral" do
      let(:text) {'I like ruby'}

      it 'returns a neutral score' do
        expect(subject).to eq 0
      end
    end

    context "when the text is negative" do
      let(:text) {'I hate ruby'}

      it 'returns a negative score' do
        expect(subject).to be < 0
      end
    end

    context "when the text has smiley" do
      let(:text) {'I love ruby'}
      let(:text_with_smiley) {'I love ruby :-)'}

      it 'scores it' do
        expect(analyzer.score(text_with_smiley)).to be > analyzer.score(text)
      end
    end

    context "when the text has punctuation" do
      let(:text) {'I love ruby'}
      let(:text_with_punctuation) {'I love, ruby'}

      it 'removes it' do
        expect(analyzer.score(text_with_punctuation)).to eq analyzer.score(text)
      end
    end

  end
end
