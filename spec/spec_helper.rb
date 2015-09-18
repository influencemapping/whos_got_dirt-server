require 'rubygems'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'rack/test'
require 'rspec'
RSpec.configure do |config|
  config.include Rack::Test::Methods
end

require File.dirname(__FILE__) + '/../app/server'
