class StockyService

  def self.get_daily_series(stock_symbol)
    request_uri = host_uri + "/time-series/#{stock_symbol}/dailies"

    response = nil
    begin
      response = HTTParty.get(request_uri, basic_auth: basic_auth)
    rescue HTTParty::Error
      Rails.logger.error('Fail to fetch from Stocky due to unexpected error!')
    rescue StandardError
      Rails.logger.error('Fail to fetch from Stocky!')
    end

    if response.present? && response.code == 200
      return response.parsed_response['data']['daily_series']
    end

    nil
  end

  def self.host_uri
    Figaro.env.STOCKY_HOST
  end

  def self.basic_auth
    { username: Figaro.env.STOCKY_USERNAME, password: Figaro.env.STOCKY_PASSWORD }
  end
end
