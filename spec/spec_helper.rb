ENV["RACK_ENV"] ||= "test"

require "dotenv"
Dotenv.load

require "pry"
require "rack/test"
require "timecop"
require "vcr"
require "webmock/rspec"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "CampMinder"

require "bundler"
Bundler.require

require File.expand_path("../dummy/config/environment", __FILE__)

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.ignore_localhost = true
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.include CampMinderSpecs
end
