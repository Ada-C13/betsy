Rails.application.routes.draw do
  get 'homepages/index'
  get 'categories/index'
  get 'categories/new'
  get 'merchants/index'
  get 'merchants/show'


  root to: "homepages#index"
  resources :products
  # get 'categories/index'
  # get 'categories/new'
  # get 'merchants/index'
  # get 'merchants/show'



  # Merchant
  resources :merchants, only: [:index]
  get "merchants/:id", to: "merchants#account", as: "account"
  # TODO: (Ross) In order to make this nested route works, we have to wait for Lak to merge her Product controller with the "index" action 
  resources :merchants do
    resources :products, only: [:index]
    # TODO: add the nested route merchants/:id/orders to show all the orders
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  put "/logout", to: "merchants#logout", as: "logout"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # TODO: (Ross) I think we need a new controller for our homepage, and that will be the root path
  # as below, for now, I will set the root == products
  root to: 'products#index'
  get "/products", to: "products#index", as: "products"
  
end
