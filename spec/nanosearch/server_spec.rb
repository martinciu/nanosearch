require 'spec_helper'

describe Nanosearch::Server do
  include Rack::Test::Methods

  before do
    @indexer = mock()
    Nanosearch::Indexer.stubs(:instance).returns(@indexer)
  end

  def app
    @app ||= Nanosearch::Server
  end

  it "should return list of indexes " do
    get '/'
    @indexer.expects(:indexes).once
    # @indexer.verify
  end

end