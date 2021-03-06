Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'sales#index'

  resources :sales, only: [:index]
  resources :inventory, only: [:index]
  resources :debts, only: [:index]
  resources :app, only: [:index]
  resources :auth, only: [:index]

  get '/sales/report_sales_daily', to: 'sales#report_sales_daily'
  get '/inventory/list_price_new', to: 'inventory#load_list_price_new'
  get '/inventory/list_price', to: 'inventory#list_price'
  get '/inventory/list_price_coro', to:'inventory#list_price_coro_xlsx'
  get '/inventory/test_price', to: 'inventory#test_price_xlsx'
  get '/sales/sku', to: 'sales#sku_view'
  get '/debts/report', to: 'debts#report_debts'
  get '/clients', to: 'client#index'
  get '/client/:id', to: 'client#show'

  get '/test', to:'inventory#list_price_auto'

  get '/app/clients', to: 'app#clients'
  post '/app/clients', to: 'app#clients'
  get '/app/products', to: 'app#products'
  post '/app/products', to: 'app#products'
  get '/app/accounts', to: 'app#accounts'
  post '/app/accounts', to: 'app#accounts'
  get '/app/orders', to: 'app#orders'
  post '/app/orders', to: 'app#orders'

  get '/auth/register', to: 'auth#register'
  post '/auth/register', to: 'auth#register'
  post '/auth/login', to: 'auth#login'

  get '/sales/routine', to: 'sales#routine'
  get '/sales/routine/:route/:day', to: 'sales#routine'
  post '/sales/routine', to: 'sales#routine'
  post '/sales/report_sales_daily', to: 'sales#generate_report_sales_daily'
  post '/sales/sales_cero', to: 'sales#sales_cero'
  post '/sales/sku', to: 'sales#sku'
  post '/inventory/price', to: 'inventory#price'
  post '/inventory/list_price', to: 'inventory#list_price_xlsx'
  post '/inventory/list_price_coro', to: 'inventory#list_price_coro_xlsx'
  post '/debts', to: 'debts#show'
  post '/debts/report', to: 'debts#generate_report_debts'
end
