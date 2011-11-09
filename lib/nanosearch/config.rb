module Nanosearch
  def self.config
    {:db => db_config}
  end

  private
    def self.db_config
      uri = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/nanosearch_development')
      config = {:host => uri.host, :dbname => uri.path[1..-1]}
      config.merge!(:user => uri.user) if uri.user
      config.merge!(:password => uri.password) if uri.password
      config
    end
end
