class StocksController < ApplicationController
  def index
  end

  def daily
    @daily_series = StockyService.get_daily_series(params[:stock_symbol])

    redirect_to root_path, notice: "Fail to show #{params[:stock_symbol]}!" if @daily_series.nil?
  end
end
