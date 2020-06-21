Rails.application.routes.draw do
  root to: 'pages#index'
  resources :pages, only: [:index]

  resources :products, except: [:destroy] do
    resources :orderitems, only: [:create]
    patch :retired, on: :member #products/1/retired
  end

  resources :orderitems, only: [:update, :destroy]
  patch 'orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'

  resources :orders, only: [:index, :show, :edit, :update]
  get '/orders/:id/cart/success', to: 'orders#success', as: 'success'
  get '/orders/:id/cart', to: 'orders#cart', as: 'cart'
  patch '/orders/:id/cancel', to: 'orders#cancel', as: 'cancel'

  resources :merchants, only: [:index, :show, :create]
  post "/auth/github", as: "github_login"
  get "/auth/:github/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"

  resources :reviews, only: [:new, :create]
  resources :categories, only: [:new, :create]
end
