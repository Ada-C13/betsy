Rails.application.routes.draw do
  root 'pages#landing'

  # Index – List orders for a Merchant (Merchant only)
  # Show  – Shows any orders from the Merchant (Merchant only)
  get "/cart", to: "orders#edit", as: "cart" 
  # Edit – Shows cart, updates credit card/address/email and confirms checkout (User)
  patch "/cart", to: "orders#update"
  # Update – Process checkout, change status to “paid” (User)
  delete "/cart", to: "orders#destroy"
  # Destroy – Empties cart (User)
  post "/orders/:id/complete", to: "orders#complete", as: "order_complete"
  # Complete – Ships the order, changes status to “complete” (Merchant only)
  post "/orders/:id/cancel", to: "orders#cancel", as: "order_cancel"
  resources :orders, only: [:index, :show, :update]
  # Cancel – Cancels the order, changes status to “cancelled” (Merchant only)
  get "/orders/:id/confirmation", to: "orders#confirmation", as: "order_confirmation"

  resources :order_items, only: [:edit, :update, :destroy]
  post "/order_items/:id/create", to: "order_items#create", as: "create_order_items"

  

  resources :products
  post "/products/:id/deactivate", to: "products#deactivate", as: "product_deactivate"
  
  resources :categories, except: [:edit, :update, :destroy]

  resources :reviews, only: [:new, :create]

  resources :merchants, only: [:index, :show] do
    member do
      get "dashboard"
      post "deactivate"
      post "logout"
    end
  end
  get 'merchants/:id/dashboard/manage_orders', to: 'merchants#manage_orders', as: "manage_orders"
  get 'merchants/:id/dashboard/manage_products', to: 'merchants#manage_products', as: "manage_products"

  # Omniauth Login route
  get "/auth/github", as: "github_login"

  # Omniauth Github callback route
  get "/auth/:provider/callback", to: "merchants#login", as: "omniauth_callback"
end
