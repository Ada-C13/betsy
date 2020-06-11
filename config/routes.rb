Rails.application.routes.draw do
  root 'homepages#landing'

  resources :orders, only: [:index, :show]
  # Edit only the shopping cart
  get "/orders/edit", to: "orders#edit", as: "order_edit" 
  post "/orders", to: "orders#update"
  delete "/orders", to: "orders#destroy" 
  post "/orders/:id/pay", to: "orders#pay", as: "order_pay"
  post "/orders/:id/complete", to: "orders#complete", as: "order_complete"
  post "/orders/:id/cancel", to: "orders#cancel", as: "order_cancel"

  resources :products
  post "/products/:id/deactivate", to: "products#deactivate", as: "product_deactivate"

  resources :merchants, only: [:show, :create]
  post "/merchants/:id/deactivate", to: "merchants#deactivate", as: "merchant_deactivate"
  get "/merchants/:id/dashboard", to: "merchants#dashboard", as: "merchant_dashboard"
  
  # Omniauth Login route
  get "/auth/github", as: "github_login"
  # Omniauth Github callback route
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  
  resources :reviews, only: [:new, :create]

  resources :categories, except: [:edit, :update, :destroy]

end
