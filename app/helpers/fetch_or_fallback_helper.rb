module FetchOrFallbackHelper
  def fetch_or_fallback(allowed_values, given_value, fallback = nil)
    if allowed_values.include?(given_value)
      given_value
    else
      unless Rails.env.production?
        raise ArgumentError, <<~MSG
          fetch_or_fallback was called with an invalid value.
          Expected one of: #{allowed_values.inspect}
          Got: #{given_value.inspect}
          This will not raise in production, but will instead fallback to: #{fallback.inspect}
        MSG
      end

      fallback
    end
  end
end
