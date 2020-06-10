Rails.application.routes.draw do
  # products
  resources :products

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
  resources :orders, except: [:index, :new] 

  # order_items
  resources :order_items, only: [:create, :update, :destroy] # an order item is created when the user adds a product to cart, index action would need to be nested in myaccount/orders
end
