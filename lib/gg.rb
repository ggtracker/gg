module GG
  class Config < Hash
    def initialize(settings = {})
      self.merge!(settings)
    end
    
    def method_missing(method, *args)
      return self[method.to_sym] if has_key?(method.to_sym)
    end
  end
  
  def self.config
    env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : (ENV['RAILS_ENV'] ? ENV['RAILS_ENV'] : 'development')
    @@config ||= Config.new({
      :host => env == 'development' ? 'localhost:9292' : 'alpha.esdb.net'
    })
  end
end

require 'rest_client'
require 'active_support/inflector'
require 'yajl'
require 'yajl/json_gem'

require 'esdb'