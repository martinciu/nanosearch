require 'spec_helper'

describe Nanosearch::Server do
  include Rack::Test::Methods

  before do
    @indexer = mock()
    Nanosearch::Indexer.stubs(:instance).returns(@indexer)
    @indexes = ["foo", "bar"]
    @indexer.stubs(:indexes).returns(@indexes)
  end

  def app
    @app ||= Nanosearch::Server
  end

  it "get root returns list of indexes" do
    get '/'
    last_response.body.must_equal "{\"indexes\":[\"foo\",\"bar\"]}"
    last_response.status.must_equal 200
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "get /baz?q=foo queries for foo in baz index" do
    @indexer.expects(:search).with("baz", "foo").returns(["1", "2"])
    get '/baz?q=foo'
    last_response.body.must_equal "[\"1\",\"2\"]"
    last_response.status.must_equal 200
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "get /baz does not query baz index" do
    @indexer.expects(:search).never
    get '/baz'
    last_response.body.must_equal "[]"
    last_response.status.must_equal 200
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "post /baz creates index baz" do
    @indexer.expects(:create_index).with("baz")
    post '/baz'
    last_response.body.must_equal "\"created\""
    last_response.status.must_equal 201
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "delete /baz removes index baz" do
    @indexer.expects(:remove_index).with("baz")
    delete '/baz'
    last_response.body.must_equal "\"ok\""
    last_response.status.must_equal 200
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "put /baz/1 adds document to index baz" do
    @indexer.expects(:index).with("baz", "1", {"body" => "Lorem ipsum", "title" => "post title"})
    put '/baz/1', "{\"body\": \"Lorem ipsum\", \"title\": \"post title\"}"
    last_response.body.must_equal "\"created\""
    last_response.status.must_equal 201
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

  it "delete /baz/1 removes document from index baz" do
    @indexer.expects(:remove).with("baz", "1")
    delete '/baz/1'
    last_response.body.must_equal "\"ok\""
    last_response.status.must_equal 200
    last_response['Content-Type'].must_equal 'application/json;charset=utf-8'
  end

end