require "rubygems"
require "bundler/setup"
require 'rspec'
require 'mocha'
require 'mimic'
require 'ap'

$:.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))

Rspec.configure do |config|
  config.color_enabled = true
  config.mock_with :mocha
end
