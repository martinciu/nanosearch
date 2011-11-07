require 'rubygems'
require 'bundler'

Bundler.require

require 'uri'
require 'nanosearch'

Nanosearch::Server.configure do |config|
  config.set :db, URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/nanosearch_development')
end

run Nanosearch::Server