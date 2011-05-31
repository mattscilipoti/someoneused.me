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

get '/usage/:id.json' do |id|
  redis.get(id).to_json
end

post '/usage' do
  redis.incr(params[:id])
end
