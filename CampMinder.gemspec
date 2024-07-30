# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "CampMinder/version"

Gem::Specification.new do |spec|
  spec.name          = "CampMinder"
  spec.version       = CampMinder::VERSION
  spec.authors       = ["Dirk Kelly", "Nathan Harper", "Aaron Todd"]
  spec.email         = ["dkelly@interexchange.org", "engineering+nharper@interexchange.org", "atodd@interexchange.org"]
  spec.summary       = "Interface for CampMinder ClientLink API."
  spec.homepage      = "https://github.com/interexchange/campminder-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5", "< 4"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rails", ">= 7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rexml" # Required since Ruby 3
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "sqlite3", "~> 1.3" # Required for resolution
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "active_model_serializers"
  spec.add_dependency "loofah"
  spec.add_dependency "nokogiri"
  spec.add_dependency "virtus"
end
