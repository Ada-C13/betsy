Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

# /product/1/order_items
  resources :products do 
    resources :order_items, only: [:index, :create, :show]
    resources :reviews, only: [:create]
  end

  #Login
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"

  #Category
  resources :categories, except: [:edit, :update, :destroy]

  #Merchant
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  resources :merchants, only: [:index, :show]

  #Order_Items
  patch "/order_items/update_status", action: :update_status, controller: 'order_items', as: "order_items_update_status"

  resources :order_items, only: [:index, :create, :update, :destroy, :show]
  
  #Orders
  resources :orders, only: [:index, :show, :update]

  # shopping cart
  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  get '/confirmation', to: 'orders#confirmation', as: 'confirmation'
end
