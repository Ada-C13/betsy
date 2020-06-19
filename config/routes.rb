Rails.application.routes.draw do

  root to: 'products#index'

  # oauth routes 
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: 'callback'
  delete "/logout", to: "merchants#logout", as: "logout"
  
  resources :merchants, only: [:create]
  get 'merchant/dashboard', to: 'merchants#dashboard', as: 'merchant_dashboard'
  post 'merchant/dashboard', to: 'merchants#dashboard'

  resources :products do
    resources :reviews, only: [:create]
  end
  resources :orders, only: [:new, :create, :show, :update]
  
  resources :categories, only: [:new, :create]
  
  get '/categories/:category_id/products', to: 'products#category_products', as: 'category_products'
  get '/merchant/:merchant_id/products', to: 'merchants#merchant_products', as: 'merchant_products'

  get 'guest/cart', to: 'order_item#cart', as: 'cart'
  post 'products/:id/add-to-cart', to: 'order_item#add_to_cart', as: 'add_to_cart'  
  post 'guest/cart/remove', to: 'order_item#remove_from_cart', as: 'remove_from_cart'
  
end
