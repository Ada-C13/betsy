Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # OAuth routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  root to: "homepages#index"

  resources :users, only: [:index, :show]
  resources :products do
    resources :order_items, only: [:create]
  end
  resources :orders, only: [:new, :show, :edit, :update]
  get "/orders/:id/finalize", to: "orders#finalize", as: "finalize_order"
  patch "/orders/:id/place_order", to: "orders#place_order", as: "place_order"
  patch "orders/:id/cancel", to: "orders#cancel_order", as: "cancel_order"
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "confirm_order"
  resources :orders, only: [:new, :show, :edit]
  resources :order_items, only: [:destroy]
  
  resources :categories, only: [:show, :new, :create]

  resources :order_items, only: [:update, :destroy]
  
  resources :reviews, except: [:index]
end
