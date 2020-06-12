Rails.application.routes.draw do

  root 'homepage#index'
  
  # products
  resources :products
  post "/products/retire/:id", to: "products#retire", as: "retire_product"

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
  resources :orders, except: :destroy # index action would need to be nested in myaccount/orders

  # order_items
  resources :order_items, except: [:index, :show] # an order item is created when the user adds a product to cart
end
