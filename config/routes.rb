Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'stocks#index'
  get '/:stock_symbol/daily', to: 'stocks#daily'

  root 'stocks#index'
end
