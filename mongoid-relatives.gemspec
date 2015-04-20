# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/relatives/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-relatives"
  spec.version       = Mongoid::Relatives::VERSION
  spec.authors       = ["epigeon"]
  spec.email         = ["epigeon@weblinc.com"]
  spec.summary       = %{Additional referenced relations for Mongoid.}
  spec.description   = %q{Referenced relations where one side is an embedded document.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
