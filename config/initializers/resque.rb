# Setup for Heroku
Resque.redis = ENV["REDISTOGO_URL"] if ENV["REDISTOGO_URL"]
Resque.redis ||= ENV["REDISCLOUD_URL"] if ENV["REDISCLOUD_URL"]