module Bittrex
  class Summary
    include Helpers

    attr_reader :name, :high, :low, :volume, :last, :base_volume,
                :raw, :created_at, :status, :message

    alias_method :vol, :volume
    alias_method :base_vol, :base_volume

    def initialize(attrs = {})
      @name        = attrs['MarketName']
      @high        = attrs['High']
      @low         = attrs['Low']
      @volume      = attrs['Volume']
      @last        = attrs['Last']
      @raw         = attrs
      @prev_day    = attrs['PrevDay']
      @status      = attrs['status']
      @message     = attrs['message']
      @created_at  = extract_timestamp(attrs['TimeStamp'])
    end

    def self.get(market_name = 'USDT-BTC')
      @status, message, results = client.public_get("public/getmarketsummary?market=#{market_name}")
      if successful?
        result = results[0]
        result.merge!("status" => @status, "message" => message)
        new(result)
      else
        fail Bittrex::RequestError, message
      end
    end

    private

    def self.successful?
      @status
    end

    def self.client
      @client ||= Bittrex.client
    end
  end
end
