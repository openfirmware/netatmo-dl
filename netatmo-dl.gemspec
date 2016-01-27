# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netatmo-dl/version'

Gem::Specification.new do |spec|
  spec.name          = "netatmo-dl"
  spec.version       = NetAtmoDL::VERSION
  spec.authors       = ["James Badger"]
  spec.email         = ["james@jamesbadger.ca"]

  spec.summary       = %q{Download CSV data from NetAtmo.}
  spec.description   = %q{Download CSV data from NetAtmo for your weather station(s). Designed for archiving.}
  spec.homepage      = "https://github.com/openfirmware/netatmo-dl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
