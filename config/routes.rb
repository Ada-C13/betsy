Rails.application.routes.draw do
  root 'pages#landing'

  resources :orders, only: [:index, :show]
  get "/cart", to: "orders#edit", as: "cart" 
  patch "/cart", to: "orders#update"
  delete "/cart", to: "orders#destroy"
  post "/orders/:id/complete", to: "orders#complete", as: "order_complete"
  post "/orders/:id/cancel", to: "orders#cancel", as: "order_cancel"
  resources :orders, only: [:index, :show, :update]

  resources :products
  post "/products/:id/deactivate", to: "products#deactivate", as: "product_deactivate"
  
  resources :categories, except: [:edit, :update, :destroy]

  resources :reviews, only: [:new, :create]

  post "/order_items/:id/create", to: "order_items#create", as: "create_order_items"
  resources :order_items, only: [:destroy]

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
