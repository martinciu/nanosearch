require 'spec_helper'

describe Nanosearch::Server do
  include Rack::Test::Methods

  def app
    @app ||= Nanosearch::Server
  end

  it "should respond to '/'" do
    get '/'
    last_response.ok?.must_equal true
  end

end