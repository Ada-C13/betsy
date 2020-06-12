Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :categories, only: [:index, :new, :create]
  get 'homepages/index'

  root to: "homepages#index"
  resources :products

  # Merchant
  resources :merchants, only: [:index]
  get "merchants/:id", to: "merchants#account", as: "account"
  # TODO: (Ross) In order to make this nested route works, we have to wait for Lak to merge her Product controller with the "index" action 
  resources :merchants do
    # this nested route will trigger the "index" action in products controller from Lak
    # this nested route will trigger the "index" action in orders controller from Yaz
    resources :orders, only: [:index]
    resources :products, only: [:create,:index]
    # TODO: add the nested route merchants/:id/orders to show all the orders
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  put "/logout", to: "merchants#logout", as: "logout"
end
