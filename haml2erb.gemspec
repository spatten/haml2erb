# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'haml2erb/version'

Gem::Specification.new do |s|
  s.name = "haml2erb"
  s.version = Haml2Erb::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = 'Louis Sivillo'
  s.email = ['louis.sivillo@gmail.com']

  s.summary = 'Haml to ERB Converter'
  s.description = 'Haml to ERB Converter'

  s.required_rubygems_version = ">= 1.3.6"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
