# app/services/stocky_service.rb

# Service to get stock data
class StockyService

  def self.get_daily_series(stock_symbol)
    request_uri = host_uri + "/time-series/#{stock_symbol}/dailies"

    response = nil
    begin
      response = HTTParty.get(request_uri, basic_auth: basic_auth)
    rescue HTTParty::Error, StandardError
      Rails.logger.error('Fail to fetch from Stocky due to unexpected error!')
    end

    return response.parsed_response['data']['daily_series'] if response.present? && response.code == 200

    nil
  end

  def self.host_uri
    Figaro.env.STOCKY_HOST
  end

  def self.basic_auth
    { username: Figaro.env.STOCKY_USERNAME, password: Figaro.env.STOCKY_PASSWORD }
  end
end
