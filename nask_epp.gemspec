# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nask_epp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marcin Nowicki", "Marcin Michałowski", "Jakub Gorzelak", "Adrian Chęciński"]
  gem.email         = ["pr0d1r2@gmail.com", "marcin@stick.pl", "jakub.gorzelak@gmail.com", "hash4di@gmail.com"]
  gem.description   = "EPP implementation for NASK domain management."
  gem.summary       = "EPP implementation"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nask_epp"
  gem.require_paths = ["lib"]
  gem.version       = NaskEpp::VERSION

  gem.add_dependency('nokogiri', '>= 1.5.5')
  gem.add_dependency('multi_json', '>= 1.6.1')
  gem.add_development_dependency('dotenv', '>= 2.0.2')
  gem.add_development_dependency('rspec', '>= 2.14.0')
  gem.add_development_dependency('rspec-its', '>= 1.2.0')
  gem.add_development_dependency('capybara', '>= 2.0.2')
  gem.add_development_dependency('vcr', '>= 2.4.0')
  gem.add_development_dependency('fakeweb', '>= 1.3.0')
  gem.add_development_dependency('guard', '>= 2.12.6')
  gem.add_development_dependency('guard-rspec', '>= 3.1.0')
end
