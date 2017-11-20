module Bittrex
  class Candles
    include Helpers

    attr_reader :high, :low, :raw, :close, :open, :created_at, :status, :message

    def initialize(attrs = {})
      @high        = attrs['H']
      @low         = attrs['L']
      @close       = attrs['C']
      @open        = attrs['O']
      @raw         = attrs
      @status      = attrs['status']
      @message     = attrs['message']
      @created_at  = extract_timestamp(attrs['T'])
    end

    def self.get(opts = {})
      opts.merge!(default_opts)
      @status, message, results = clientv2.public_get("pub/market/GetTicks", opts)
      if successful?
        prepared_results = prepare_results(results)
        { status: @status, message: message, results: prepared_results }
      else
        fail Bittrex::RequestError, message
      end
    end

    private

    def self.prepare_results(results)
      results.map { |r| new(r) }
    end

    def self.default_opts
      { marketName: "USDT-BTC", tickInterval: "oneMin" }
    end

    def self.successful?
      @status
    end

    def self.clientv2
      @client ||= Bittrex.clientv2
    end
  end
end
