require 'sinatra/base'
require 'json'

module Nanosearch
   
  class Server < Sinatra::Base

    helpers do
      def indexer
        Indexer.instance
      end

      def render_json(body)
        content_type :json
        body.to_json
      end

      def respond(message = :ok)
        case message
          when :created
            status 201
          else
            status 200
        end
        render_json message       
      end
    end

    get '/' do
      render_json :indexes => indexer.indexes
    end

    get '/:index' do
      render_json params[:q] ? indexer.search(params[:index], params[:q]) : []
    end

    post '/:index' do
      indexer.create_index(params[:index])
      respond :created
    end

    delete '/:index' do
      indexer.remove_index(params[:index])
      respond :ok
    end

    put '/:index/:doc_id' do
      indexer.index(params[:index], params[:doc_id], JSON.parse(request.body.read))
      respond :created
    end

    delete '/:index/:doc_id' do
      indexer.remove(params[:index], params[:doc_id])
      respond :ok
    end
  end

end