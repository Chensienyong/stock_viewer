class StocksController < ApplicationController
  def index
    @stock_symbol = params[:search]

    return if @stock_symbol.nil?

    @daily_series = StockyService.get_daily_series(@stock_symbol)

    flash[:error] = "Fail to show #{@stock_symbol}!" if @daily_series.nil?
  end
end
