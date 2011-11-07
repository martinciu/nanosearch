require 'rubygems'
require 'bundler'

Bundler.require

require 'nanosearch'

Nanosearch::Server.configure do |config|
  config.set :db, YAML::load(File.open("config/database.yml"))[ENV['RACK_ENV']]
end

run Nanosearch::Server