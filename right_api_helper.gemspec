# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'right_api_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "right_api_helper"
  spec.version       = RightApiHelper::VERSION
  spec.authors       = ["caryp"]
  spec.email         = ["cary@rightscale.com"]
  spec.summary       = %q{A collection of helper objects and methods for right_api_client gem}
  spec.description   = %q{A collection of helper objects and methods for right_api_client gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "right_api_client", "~> 1.5.15"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr", "~> 2.9.0"
  spec.add_development_dependency "pry"
end
