require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Open an irb session preloaded with sentimental.rb"
task :console do
  exec "irb -r sentimental -I ./lib"
end
