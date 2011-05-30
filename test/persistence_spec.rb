# see: http://sinatra-book-contrib.com/p/testing/minitest
ENV['RACK_ENV'] = 'test'


require 'minitest/autorun'
require 'rack/test'

begin
  require_relative '../someoneusedme'
  # redis.connections.each {|r| r.flushdb }
  redis.flushdb
rescue LoadError
  require File.expand_path('../someoneusedme', __FILE__)
end

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app() Sinatra::Application end

  def test_post_to_usage_should_increment_count
    post '/usage', {:id => 'TEST'}
    assert last_response.ok?, "expected ok, got #{last_response.status}"

    get "/usage/TEST"
    assert last_response.ok?
    assert_equal '1', last_response.body
  end
end

