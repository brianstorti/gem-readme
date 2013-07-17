# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems/version'

Gem::Specification.new do |spec|
  spec.name          = "gem-readme"
  spec.version       = Rubygems::VERSION
  spec.authors       = ["Brian Thomas Storti"]
  spec.email         = ["btstorti@gmail.com"]
  spec.description   = %q{Read a gem's README file directlty in your terminal}
  spec.summary       = %q{Read a gem's README file directlty in your terminal}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
