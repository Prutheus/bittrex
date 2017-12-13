module Bittrex
  class Summary
    include Helpers

    attr_reader :name, :high, :low, :volume, :last, :base_volume,
                :raw, :created_at, :status, :message

    alias vol volume
    alias base_vol base_volume

    def initialize(attrs = {})
      @name        = attrs['MarketName']
      @high        = attrs['High']
      @low         = attrs['Low']
      @volume      = attrs['Volume']
      @base_volume = attrs['BaseVolume']
      @last        = attrs['Last']
      @raw         = attrs
      @prev_day    = attrs['PrevDay']
      @status      = attrs['status']
      @message     = attrs['message']
      @created_at  = extract_timestamp(attrs['TimeStamp'])
    end

    def self.all
      client.public_get('public/getmarketsummaries')[2].map { |data| new(data) }
    end

    def self.get(market = 'USDT-BTC')
      opts = { market: market }
      @status, message, results = client.public_get('public/getmarketsummary', opts)
      if successful?
        result = results[0]
        result['status'] = @status
        result['message'] = message
        new(result)
      else
        raise Bittrex::RequestError, message
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
