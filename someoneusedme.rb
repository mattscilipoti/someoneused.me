require 'haml'
require 'json'
require 'sinatra'
require 'sinatra/redis'

# Establish the database connection; or, omit this and use the REDIS_URL
# environment variable as the connection string; or, default to redis://locahost:6379/0
#
# NOTE: The database is the integer in the path
# set :redis, 'redis://some-remote-server:1234/5'
# At this point, you can access the Redis object using the "redis" object:

# References:
# * http://www.slideshare.net/adamwiggins/rails-metal-rack-and-sinatra
# * http://www.scribd.com/doc/14171941/Lightweight-Webservices-with-Sinatra-and-RestClient
# * respond_with: https://github.com/sinatra/sinatra-contrib/blob/master/lib/sinatra/respond_with.rb
# * https://github.com/cehoffman/sinatra-respond_to

get '/usage/:id.json' do |id|
  data = { :usages => redis.get(id) }
  data.to_json
end

# get '/usage/:id', :provides => [:html, :json] do |id|
get '/usage/:id' do |id|
  data = { :usages => redis.get(id) }
puts "\na=#{request.accept.inspect}"
puts "\nr=#{request.inspect}"
  request.accept.each do |type|
    case type
    when 'application/json'
      halt data.to_json
    when 'text/html'
      halt haml(:get, :locals => data)
    end
  end
  error 406
end

post '/usage' do
  redis.incr(params[:id])
end

__END__
@@ layout
%html
  %head
    %title Haml on Sinatra Example
  %body
    =yield

@@ get
#header
  %h1 Haml on Sinatra Example
#content
  %p
    This is an example of using Haml on Sinatra.
    You can use Haml in all your projeccts now, instead
    of Erb. I'm sure you'll find it much easier!

