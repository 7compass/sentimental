#
# Use this script to transform text files to JSON.
# The text files must have this format:
#   SCORE WORD
#
# Where SCORE is a float number that represents the WORD sentiment value
#
# To run the script:
#   $> ruby JSON_builder.rb sentiwords.txt en_words.json
#
require 'json'
require_relative '../lib/file_reader'
include FileReader

file_input_name = ARGV[0]
file_output_name = ARGV[1]

json = FileReader.hash_from_txt(file_input_name)

file_output = File.open(file_output_name, 'w+')
file_output.write(JSON.pretty_generate(json))
