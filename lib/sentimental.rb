
# Based on code from https://github.com/cmaclell/Basic-Tweet-Sentiment-Analyzer


#############################################################################
# Copyright: Christopher MacLellan 2010
# Description: This code adds functions to the string class for calculating
#              the sentivalue of strings. It is not called directly by the
#              tweet-search-sentiment.rb program but is included for possible 
#              future use.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################

# 
# In an initializer, you can initialize some global defaults:
# 
#   Sentimental.load_defaults
#   Sentimental.threshold = 0.1
# 
# Then create an instance for usage:
# 
#   analyzer = Sentimental.new
#   analyzer.get_sentiment('I love your service')
#   => :positive
# 
# You can make new analyzers with individual thresholds:
# 
#   analyzer = Sentimental.new(0.9)
#   analyzer.get_sentiment('I love your service')
#   => :positive
#   analyzer.get_sentiment('I like your service')
#   => :neutral
# 
class Sentimental
  @@sentihash = {}
  @@threshold = 0.0

  def initialize(threshold = nil)
    @threshold = threshold || @@threshold
  end

  #####################################################################
  # Function that returns the sentiment value for a given string.
  # This value is the sum of the sentiment values of each of the words.
  # Stop words are NOT removed.
  #
  # return:float -- sentiment value of the current string
  #####################################################################
  def get_score(string)
    sentiment_total = 0.0

    #tokenize the string, also throw away some punctuation
    tokens = string.to_s.downcase.split(/[\s\!\?\.]+/)
    
    tokens.each do |token|
      sentiment_value = @@sentihash[token]
      sentiment_total += sentiment_value if sentiment_value
    end
    sentiment_total
  end

  def get_sentiment(string)
    score = get_score(string)

    # if less then the negative threshold classify negative
    if score < (-1 * @threshold)
      :negative
    # if greater then the positive threshold classify positive
    elsif score > @threshold
      :positive
    else
      :neutral
    end
  end
  
  # Loads the default sentiment files
  def self.load_defaults
    load_senti_file(File.dirname(__FILE__) + '/sentiwords.txt')
    load_senti_file(File.dirname(__FILE__) + '/sentislang.txt')
  end

  #####################################################################
  # load the specified sentiment file into a hash
  #
  # filename:string -- name of file to load
  # sentihash:hash -- hash to load data into
  # return:hash -- hash with data loaded
  #####################################################################
  def self.load_senti_file(filename)
    # load the word file
    file = File.new(filename)
    while (line = file.gets)
      parsedline = line.chomp.split(/\s/)
      sentiscore = parsedline[0]
      text = parsedline[1]
      @@sentihash[text] = sentiscore.to_f
    end
    file.close
  end

  def self.threshold=(threshold)
    @@threshold = threshold
  end
  
end 
