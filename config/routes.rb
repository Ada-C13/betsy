Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # OAuth routes
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"

  root to: "homepages#index"

  get "/meet_the_team", to: "homepages#meet_the_team", as: "meet_the_team"

  resources :users, only: [:index, :show]
  get "/myaccount", to: "users#myaccount", as: "myaccount"
  get "/myaccount/orders", to: "users#myorders", as: "myorders"

  resources :products, except: [:destroy] do
    resources :order_items, only: [:create]
    resources :reviews, only: [:show, :new, :create]
  end

  resources :orders, only: [:new, :show, :edit, :update]
  get "/orders/:id/finalize", to: "orders#finalize", as: "finalize_order"
  patch "/orders/:id/place_order", to: "orders#place_order", as: "place_order"
  patch "orders/:id/cancel", to: "orders#cancel_order", as: "cancel_order"
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "confirm_order"
  
  patch "/products/:id/change_product_status", to: "products#change_product_status", as: "change_product_status"

  patch "/order_items/:id/change_order_item_status", to: "order_items#change_order_item_status", as: "change_order_item_status"



  resources :orders, only: [:new, :show, :edit]
  resources :order_items, only: [:destroy]
  
  resources :categories, only: [:show, :new, :create]

  resources :order_items, only: [:update, :destroy]
end
