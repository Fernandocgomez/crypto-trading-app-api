Rails.application.routes.draw do

  # root
  root to: "home#index"

  # Auth routes
  post '/login', to: 'auth#create'


  # Crypto assests routes
  post '/buy_crypto_by_unit', to: 'crypto_assets#buy_crypto_by_unit'
  delete '/sell_all_crypto/:id', to: 'crypto_assets#sell_all_crypto'
  put '/sell_crypto_by_unit/:id/:num_of_units', to: 'crypto_assets#sell_crypto_by_unit'

  # Portafolio route
  put '/add_funds/:id', to: 'portafolios#add_funds'
  put '/update_price_on_portafolio/:id', to: 'portafolios#update_price_on_portafolio'


  resources :crypto_assets, only: [:index, :show]
  resources :portafolios, only: [:show]
  resources :users, only: [:show, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end