# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'h2ocube_rails_helper'
  gem.version       = '0.2.1'
  gem.authors       = ['Ben']
  gem.email         = ['ben@h2ocube.com']
  gem.description   = 'Just an helper collection'
  gem.summary       = 'Just an helper collection'
  gem.homepage      = 'https://github.com/h2ocube/h2ocube_rails_helper'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'browser'

  gem.add_development_dependency 'tzinfo'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'sqlite3'
end
