Rails.application.routes.draw do
  # products
  resources :products do
    post "/add", to: "order_items#create"
  end

  # categories
  resources :categories, only: [:show, :new, :create]

  # reviews
  resources :reviews, only: [:new, :create]
  
  # merchants
  get "/merchant/:id", to: "merchants#show", as: "merchant"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"

  # orders
  resources :orders, only: [:index, :show, :update, :destroy]
  get "orders/checkout", to: "orders#checkout" # we can leverage session[:order_id] here instead of passing in params through the route

  # order_items
  resources :order_items, only: [:update, :destroy]
end
