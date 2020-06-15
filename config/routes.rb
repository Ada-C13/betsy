Rails.application.routes.draw do
  root to: 'pages#index'
  resources :pages, only: :index

  resources :products do
    resources :orderitems, only: [:create]
  end

  resources :orderitems, only: [:update, :destroy]
  patch 'orderitems/:id/mark_shipped', to: 'orderitems#mark_shipped', as: 'mark_shipped'

  resources :orders, only: [:show, :edit, :update]
  get '/orders/:id/cart', to: 'orders#cart', as: 'cart'
  # need custom route for place order?

  resources :merchants

  post "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"
  get '/orders/:id/merchant_order', to: 'orders#merchant_order', as: 'merchant_order'

  resources :reviews, only: [:new, :create]
  resources :categories, only: [:new, :create, :show, :index]
end
