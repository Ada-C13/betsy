Rails.application.routes.draw do
  root 'pages#landing'

  resources :orders, only: [:index, :show]
  # Edit only the shopping cart
  get "/cart", to: "orders#edit", as: "cart" 
  post "/cart", to: "orders#update"
  delete "/cart", to: "orders#destroy" 
  post "/cart/checkout", to: "orders#checkout", as: "cart_checkout"
  post "/orders/:id/complete", to: "orders#complete", as: "order_complete"
  post "/orders/:id/cancel", to: "orders#cancel", as: "order_cancel"

  resources :products
  post "/products/:id/deactivate", to: "products#deactivate", as: "product_deactivate"
  

  resources :categories, except: [:edit, :update, :destroy]

  resources :reviews, only: [:new, :create]

  resources :merchants, only: [:index, :show] do
    member do
      get "dashboard"
      post "deactivate"
    end
  end
  get 'merchants/:id/dashboard/manage_orders', to: 'merchants#manage_orders', as: "manage_orders"
  get 'merchants/:id/dashboard/manage_products', to: 'merchants#manage_products', as: "manage_products"

  # Omniauth Login route
  get "/auth/github", as: "github_login"

  # Omniauth Github callback route
  get "/auth/:provider/callback", to: "merchants#login", as: "omniauth_callback"
  
  delete "/logout", to: "merchants#logout", as: "logout"


end
