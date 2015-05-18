require_relative 'testapp/config/environment'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'

def random_string
  SecureRandom.uuid
end
