require 'sinatra/base'

module Nanosearch
   
  class Server < Sinatra::Base
    
    get '/' do
      'Hello nanosearch!'
    end
  end

end