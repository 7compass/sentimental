Gem::Specification.new do |spec|
  spec.name         = 'sentimental'
  spec.version      = '1.4.1'
  spec.summary      = 'Simple sentiment analysis'
  spec.description  = 'A simple sentiment analysis gem'
  spec.authors      = ['Jeff Emminger', 'Christopher MacLellan', 'Denis Pasin']
  spec.email        = ['jeff@7compass.com', 'denis@hellojam.fr']
  spec.homepage     = 'https://github.com/7compass/sentimental'
  spec.license      = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "rubocop", "~> 0.40", ">= 0.40.0"
end
