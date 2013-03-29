# sentimental

Simple sentiment analysis with Ruby

## How it works

Sentences are tokenized, tokens are assigned a numerical score
for their average sentiment.  The total score is then used to 
determine the overall sentiment in relation to the thresold.

For example, the default threshold is 0.0.  If a sentence has
a score of 0, it is deemed "neutral".  Higher than the thresold
is "positive", lower is "negative".  

If you set the threshold to a non-zero amount, e.g. 0.25:

Positive scores are > 0.25
Neutral scores are -0.25 - 0.25
Negative scores are < -0.25


## Usage

```ruby

# Load the default sentiment dictionaries
  Sentimental.load_defaults

# Set a global threshold
  Sentimental.threshold = 0.1

# Then create an instance for usage:

  analyzer = Sentimental.new
  analyzer.get_sentiment 'I love ruby'
  #=> :positive

  analyzer.get_sentiment 'I like ruby'
  #=> :neutral

  analyzer.get_sentiment 'I really like ruby'
  #=> :positive

# You can make new analyzers with individual thresholds:

  analyzer = Sentimental.new(0.9)
  analyzer.get_sentiment 'I love ruby'
  => :positive

  analyzer.get_sentiment 'I like ruby'
  => :neutral
   
  analyzer.get_sentiment 'I really like ruby'
  #=> :neutral

# Get the numerical score of a string:

  analyzer.get_score 'I love ruby'
  #=> 0.925

```

## Installation 

    gem install sentimental

## Credits

Based largely on Christopher MacLellan's script here:
https://github.com/cmaclell/Basic-Tweet-Sentiment-Analyzer
