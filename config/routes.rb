Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'sales#index'

  resources :sales, only: [:index]
  resources :inventory, only: [:index]

  get '/sales/report_sales_daily', to: 'sales#report_sales_daily'
  get '/inventory/list_price', to: 'inventory#list_price'
  get '/inventory/list_price_new', to: 'inventory#list_price_new'  

  post '/sales/report_sales_daily', to: 'sales#generate_report_sales_daily'
  post '/sales/sales_cero', to: 'sales#sales_cero'
  post '/inventory/price', to: 'inventory#price'
  

end
