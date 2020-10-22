Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'sales#index'

  resources :sales, only: [:index]
  resources :inventory, only: [:index]

  get '/inventory/list_price', to: 'inventory#list_price'
  post '/sales/sales_cero', to: 'sales#sales_cero'
  post '/inventory/price', to: 'inventory#price'

end
