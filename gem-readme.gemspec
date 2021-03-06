# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "gem-readme"
  spec.version       = "1.0.2"
  spec.authors       = ["Brian Thomas Storti"]
  spec.email         = ["btstorti@gmail.com"]
  spec.description   = %q{Read a gem's README file directlty in your terminal}
  spec.summary       = %q{Read a gem's README file directlty in your terminal}
  spec.homepage      = "https://github.com/brianstorti/gem-readme"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
