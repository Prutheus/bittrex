module Bittrex
  class Trade

    attr_reader :market_name, :trade_type, :quantity, :rate, :order_type,
                :order_id, :market_currency

    def initialize(attrs = {})
      @order_id            = attrs['OrderId']
      @market_name         = attrs['MarketName']
      @market_currency     = attrs['MarketCurrency']
      @trade_type          = attrs['BuyOrSell']
      @quantity            = attrs['Quantity']
      @rate                = attrs['Rate']
      @order_type          = attrs['OrderType']
    end

    def self.buy(opts = {})
      opts = default_opts.merge(opts)
      @status, message, results = clientv2.
        credential_get("key/market/TradeBuy", opts)
      if successful?
        result = new(results)
        { status: @status, message: message, result: result }
      else
        fail Bittrex::RequestError, message
      end
    end

    def self.sell(opts = {})
      opts = default_opts.merge(opts)
      @status, message, results = clientv2.
        credential_get("key/market/TradeSell", opts)
      if successful?
        result = new(results)
        { status: @status, message: message, result: result }
      else
        fail Bittrex::RequestError, message
      end
    end

    private

    def self.default_opts
      { 
        MarketName: "USDT-BTC",
        OrderType: "LIMIT",
        TimeInEffect: "IMMEDIATE_OR_CANCEL",
        ConditionType: "NONE",
        Target: 0
     }
    end

    def self.successful?
      @status
    end

    def self.clientv2
      @client ||= Bittrex.clientv2
    end
  end
end
