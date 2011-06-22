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

USE_CHARLES_PROXY = false

def mimic_port
  if USE_CHARLES_PROXY
    11989
  else
    Mimic::MIMIC_DEFAULT_PORT
  end
end
