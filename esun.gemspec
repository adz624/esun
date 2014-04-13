# -*- encoding: utf-8 -*-
require File.expand_path('../lib/esun/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "esun"
  s.version     = Esun::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "taiwan esun bank vitural account service."
  s.description = "virtual account generator, and payment callback parser"

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.authors  = ["Eddie"]
  s.email    = ["eddie@visionbundles.com"]
  s.homepage = "https://github.com/afunction/esun"

  s.files            = %w{.gitignore Rakefile Gemfile README.rdoc LICENSE esun.gemspec} + Dir['**/*.{rb,yml}']
  s.test_files       = s.files.grep(%r{^(test|spec|locales)/})
  s.require_paths    = %w{lib}

  s.license          = 'MIT'

  s.add_dependency "rails"
  s.add_development_dependency "rspec"
end
