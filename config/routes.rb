Rails.application.routes.draw do
  root 'pages#landing'

  resources :orders, only: [:index, :show]
  # Edit only the shopping cart
  get "/cart", to: "orders#edit", as: "cart" 
  post "/cart", to: "orders#update"
  delete "/cart", to: "orders#destroy" 
  post "/orders/:id/pay", to: "orders#pay", as: "order_pay"
  post "/orders/:id/complete", to: "orders#complete", as: "order_complete"
  post "/orders/:id/cancel", to: "orders#cancel", as: "order_cancel"

  resources :products
  post "/products/:id/deactivate", to: "products#deactivate", as: "product_deactivate"
  

  resources :categories, except: [:edit, :update, :destroy]

  resources :reviews, only: [:new, :create]

  post '/order_item/:id', to: 'order_items#create', as: 'create_order_item'

 
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
  post "/merchants/:id/deactivate", to: "merchants#deactivate", as: "deactivate"
  get "/merchants/:id/dashboard", to: "merchants#dashboard", as: "dashboard"
  resources :merchants, only: [:index, :show] 

  # Omniauth Login route
  get "/auth/github", as: "github_login"

  # Omniauth Github callback route
  get "/auth/:provider/callback", to: "merchants#login", as: "omniauth_callback"
  
  delete "/logout", to: "merchants#logout", as: "logout"


end
