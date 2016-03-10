require_relative "../lib/sentimental"

describe Sentimental do

  before :each do
    analyzer.load_defaults
  end

  let(:analyzer) { Sentimental.new(threshold: 0.1) }

  describe "#score" do
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
end
