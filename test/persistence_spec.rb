# see: http://sinatra-book-contrib.com/p/testing/minitest
ENV['RACK_ENV'] = 'test'


gem 'minitest'
require 'minitest/autorun'
require 'rack/test'

begin
  require_relative '../someoneusedme'
  set :redis, 'redis://localhost:6379/0'
  # redis.connections.each {|r| r.flushdb }
  redis.flushdb
rescue LoadError
  require File.expand_path('../someoneusedme', __FILE__)
end

# clean db before each run
MiniTest::Unit::TestCase.class_eval do
  def setup
    redis.flushdb
  end
end

include Rack::Test::Methods

def app
  Sinatra::Application
end


describe "post /usage, :id" do
  it "should incr the key" do
    post '/usage', {:id => 'TEST'}
    assert last_response.ok?, "expected ok, got #{last_response.status}"

    get "usage/TEST.json"
    assert last_response.ok?, "expected ok, got #{last_response.status}"
    last_response.body.must_equal '1'.to_json
  end
end

