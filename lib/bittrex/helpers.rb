module Bittrex
  module Helpers
    def extract_timestamp(value)
      return if value.nil? || value.strip.empty?
      Time.parse value
    end
  end
end
