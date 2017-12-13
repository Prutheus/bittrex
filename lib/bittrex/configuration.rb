require 'singleton'

module Bittrex
  class Configuration
    include Singleton

    attr_accessor :key, :secret, :api_version

    @@defaults = {
      key: ENV['BITTREX_API_KEY'],
      secret: ENV['BITTREX_API_SECRET'],
      api_version: ENV['BITTREX_API_VERSION']
    }

    def self.defaults
      @@defaults
    end

    def initialize
      reset
    end

    def auth
      {
        key: key,
        secret: secret,
        api_version: api_version
      }
    end

    def reset
      @@defaults.each_pair { |k, v| send("#{k}=", v) }
    end
  end
end
