Rails.application.routes.draw do
  root to: "homepages#index"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_calback"
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "/merchants/current", to: "merchants#current", as: "current_merchant"

  get "/merchants/current/dashboard", to: "merchants#dashboard", as: "current_merchant_dashboard"
  get "/about", to: "homepages#about", as: "about"


  resources :merchants

  resources :products
  resources :categories, only: [:show, :new, :create]

  resources :orders
  get "/orders/:id/manage", to: "orders#manage", as: "orders_manage"
  patch "/orders/:id/cancel", to: "orders#cancel_order", as: "cancel_order"
  patch "/orders/:id/complete", to: "orders#complete_order", as: "complete_order"

  resources :order_items
  get "/orders/:id/status", to: "orders#status", as: "status"

  patch "/product/:id/retire", to: "products#retire", as: "retire_product"
  resources :products do
    resources :order_items, only: [:index, :new, :create]
    resources :reviews, only: [:new, :create]
  end

  resources :orders do
    resources :order_items, only: [:update]
  end

end
