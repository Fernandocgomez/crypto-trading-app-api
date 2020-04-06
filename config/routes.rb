Rails.application.routes.draw do

  # root
  root to: "home#index"

  # Auth routes
  post '/login', to: 'auth#create'

  # Portafolio route
  put '/add_funds/:id', to: 'portafolios#add_funds'
  put '/update_price_on_portafolio/:id', to: 'portafolios#update_price_on_portafolio'
  get '/available_crypto_balance_usd/id', to: 'portafolios#available_crypto_balance_usd'

  # Crypto assests routes
  post '/buy_crypto', to: 'crypto_assets#buy_crypto'
  put '/sell_crypto/:id', to: 'crypto_assets#sell_crypto'


  # Balance Tracking
  get '/balance_tracking_data/:id', to: 'balance_trackings#portfolio_balance_tracking'


  resources :crypto_assets, only: [:index, :show]
  resources :portafolios, only: [:show]
  resources :users, only: [:show, :create, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end