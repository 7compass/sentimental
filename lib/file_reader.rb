require 'json'

module FileReader
  def hash_from_txt(filename)
    new_words = {}
    File.open(filename) do |file|
      file.each_line do |line|
        parsed_line = line.chomp.scan(/^([^\s]+)\s+(.+)/).first
        next unless parsed_line
        new_words[parsed_line[1]] = parsed_line[0].to_f
      end
    end
    new_words
  end

  def hash_from_json(filename)
    JSON.parse(File.read(filename))
  end
end
