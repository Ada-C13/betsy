Rails.application.routes.draw do
  # get 'categories/index'
  # get 'categories/new'
  # get 'merchants/index'
  # get 'merchants/show'



  # resources :merchants, only[:show]
  resources :merchants, only: [:index]

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  put "/logout", to: "merchants#logout", as: "logout"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # TODO: (Ross) I think we need a new controller for our homepage, and that will be the root path
  # as below, for now, I will set the root == products
  root to: 'products#index'
  get "/products", to: "products#index", as: "products"
  
end
