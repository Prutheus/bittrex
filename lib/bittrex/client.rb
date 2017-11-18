require 'faraday'
require 'base64'
require 'json'

module Bittrex
  class Client

    HOST = {
      "v1" => "https://bittrex.com/api/v1.1",
      "v2" => "https://bittrex.com/Api/v2.0"
    }

    attr_reader :key, :secret, :api_version

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
      @api_version = attrs[:api_version]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      host = HOST[api_version]
      response = connection.get do |req|
        url = "#{host}/#{path}"
        req.params.merge!(params)
        req.url(url)
        if key
          req.params[:apikey]   = key
          req.params[:nonce]    = nonce
          req.headers[:apisign] = signature(url, nonce)
        end
      end
      prepare_response_object(response)
    end

    private

    def prepare_response_object(response)
      response_body = JSON.parse(response.body)
      success = response_body['success']
      message = response_body['message']
      result = response_body['result']

      [success, message, result]
    end

    def signature(url, nonce)
      OpenSSL::HMAC.hexdigest('sha512', secret, "#{url}?apikey=#{key}&nonce=#{nonce}")
    end

    def connection
      host = HOST[api_version]
      @connection ||= Faraday.new(:url => host) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
