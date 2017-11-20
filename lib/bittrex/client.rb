require 'base64'
require 'json'
require 'openssl'

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

    def public_get(path, params = {}, headers = {})
      url = "#{host}/#{path}"
      full_url = get_full_url(url: url, params: params)
      response = RestClient.get(full_url)
      prepare_response_object(response)
    end
  
    def credential_get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      url = "#{host}/#{path}"
      credential = { nonce: nonce, apikey: key }
      full_url = get_full_url(url: url, credential: credential, params: params)
      response = RestClient.get(full_url, { apisign: signature(full_url) })
      prepare_response_object(response)
    end

    private

    def host
      HOST[api_version]
    end

    def get_full_url(url:, params:, credential: {})
      params.merge!(credential)
      params_str = params.map { |k, v| "#{k}=#{v}"}.join("&")
      "#{url}?#{params_str}"
    end

    def prepare_response_object(response)
      response_body = JSON.parse(response.body)
      success = response_body['success']
      message = response_body['message']
      result = response_body['result']

      [success, message, result]
    end

    def signature(url)
      OpenSSL::HMAC.hexdigest('sha512', secret, url)
    end
  end
end
