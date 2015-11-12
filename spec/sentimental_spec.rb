require_relative "../lib/sentimental"

describe Sentimental do

   before :each do
    Sentimental.load_defaults
    Sentimental.threshold = 0.1
    @analyzer = Sentimental.new
  end

  describe "#get_score" do

    it "returns a score of 0.925 when passed 'I love ruby'" do
      @analyzer.get_score('I love ruby').should eq(0.925)
    end

    it "returns a score of 0.0 when passed 'I like ruby'" do
      @analyzer.get_score('I like ruby').should eq(0.0)
    end

    it "returns a score of -0.4375 when passed 'I hate ruby'" do
      @analyzer.get_score('I hate ruby').should eq(-0.4375)
    end

    it "sentences are scored equally regardless of punctuation" do
      score1 = @analyzer.get_score('I love ruby')
      score2 = @analyzer.get_score('#$%^I@ love! ruby!@#$%^&*()')
      score1.should eq(score2)
    end

  end

end
