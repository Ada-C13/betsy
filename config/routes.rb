Rails.application.routes.draw do

  root 'homepage#index'
  
  # products
  resources :products

  post "/products/retire/:id", to: "products#retire", as: "retire_product"
  post "/products/:id/add_to_cart", to: "products#add_to_cart", as: "add_to_cart"

  # categories
  resources :categories, only: [:show, :new, :create]

  # reviews
  resources :reviews, only: [:new, :create]
  
  # merchants
  resources :merchants, only: [:show] do
    resources :products, only: [:index]
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"

  # orders
  resources :orders, only: [:index, :show, :update, :destroy]
  get "orders/checkout", to: "orders#checkout" # we can leverage session[:order_id] here instead of passing in params through the route

  # order_items
  resources :order_items, only: [:update, :destroy]
end
