Rails.application.routes.draw do
  # products
  resources :products

  # categories
  resources :categories, only: [:show, :new, :create]

  # reviews
  resources :reviews, only: [:new, :create]
  
  # merchants
  resources :merchants, only: [:show] do
    resources :products, only: [:index]
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"

  # orders
  resources :orders, except: :destroy # index action would need to be nested in myaccount/orders

  # order_items
  resources :order_items, except: [:index, :show] # an order item is created when the user adds a product to cart
end
