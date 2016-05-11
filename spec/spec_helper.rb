def create_test_files
  Dir.mkdir('spec/test_data') unless Dir.exist?('spec/test_data')
  File.open('spec/test_data/test.txt', 'w+') do |file|
    file.puts('1.0 TEST')
    file.puts('-1.0 :(')
  end
  File.open('spec/test_data/test.json', 'w+') do |file|
    file.puts('{"TEST":1.0,":(":-1.0}')
  end
end

create_test_files
