require "bittrex/version"
require "dotenv/load"
require "time"
require "rest-client"

module Bittrex
  autoload :Helpers,       'bittrex/helpers'
  autoload :Market,        'bittrex/market'
  autoload :Client,        'bittrex/client'
  autoload :Configuration, 'bittrex/configuration'
  autoload :Currency,      'bittrex/currency'
  autoload :Deposit,       'bittrex/deposit'
  autoload :Order,         'bittrex/order'
  autoload :Quote,         'bittrex/quote'
  autoload :Summary,       'bittrex/summary'
  autoload :Wallet,        'bittrex/wallet'
  autoload :Withdrawal,    'bittrex/withdrawal'
  autoload :Candles,       'bittrex/candles'
  autoload :Trade,         'bittrex/trade'

  class RequestError < StandardError; end

  def self.client
    params = configuration.auth.merge(api_version: "v1")
    @client ||= Client.new(params)
  end

  def self.clientv2
    params = configuration.auth.merge(api_version: "v2")
    @clientv2 ||= Client.new(params)
  end

  def self.config
    yield configuration
    @client = Client.new(configuration.auth)
  end

  def self.configuration
    Configuration.instance
  end

  def self.root
    File.expand_path('../..', __FILE__)
  end
end
