Rails.application.routes.draw do
  
  get 'products/index'

  root to: 'products#index'
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"

  #resources :merchants
  resources :products
  resources :carts
  resources :order_items
  resources :categories
  resources :reviews
  

end
