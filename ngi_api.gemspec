# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ngi_api/version'

Gem::Specification.new do |spec|
  spec.name          = "ngi_api"
  spec.version       = NgiAPI::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Marco Bulgarini"]
  spec.email         = ["marco.bulgarini@com-net.it"]
  spec.summary       = "NGI official APIs"
  spec.description   = "A ruby way to access NGI APIs."
  spec.homepage      = "http://rubygems.org/gems/ngi_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  # spec.add_runtime_dependency "digest"    # no need to add stdlib!
  # spec.add_runtime_dependency "net/http"  # no need to add stdlib!
  spec.add_runtime_dependency "rubyntlm", "~> 0.3.2"
  spec.add_runtime_dependency "savon"
end
