require 'pg'
require 'yaml'
require 'singleton'
require 'uri'

module Nanosearch
  class Indexer
    include Singleton
    attr_accessor :connection

    def initialize
      @connection = PGconn.open(db_config)
    end

    def indexes
      @connection.exec("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'").map {|row| row['table_name']}
    end

    def create_index(index)
      remove_index(index)
      @connection.exec "CREATE TABLE #{index} (doc_id varchar(255), ts_vector tsvector)"
      @connection.exec "CREATE UNIQUE INDEX #{index}_doc_id_idx ON #{index} (doc_id)"
    end

    def remove_index(index)
      @connection.exec "DROP TABLE IF EXISTS #{index}"
    end

    def index(index, doc_id, document)
      @connection.exec "INSERT INTO #{index} (doc_id, ts_vector) VALUES(#{doc_id}, to_tsvector('#{document.values.join(' ')}'))"
    rescue PGError => e
      @connection.exec "UPDATE #{index} SET ts_vector = to_tsvector('#{document.values.join(' ')}') WHERE doc_id = '#{doc_id}'"
    end

    def remove(index, doc_id)
      @connection.exec "DELETE FROM #{index} WHERE doc_id = '#{doc_id}'"
    end

    def search(index, query)
      @connection.exec("SELECT doc_id FROM #{index} where ts_vector @@ plainto_tsquery('#{query}')").map {|r| r['doc_id']}
    end

    private
      def db_config
        uri = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/nanosearch_development')
        config = {:host => uri.host, :dbname => uri.path[1..-1]}
        config.merge!(:user => uri.user) if uri.user
        config.merge!(:password => uri.password) if uri.password
        config
      end
  end
end