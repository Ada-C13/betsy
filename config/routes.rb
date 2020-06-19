Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homepages#index"
  resources :categories, only: [:index, :new, :create]
  get "/categories/:id/products", to: "categories#category_products", as: "category_product"

  # Products + Review
  resources :products do
    resources :reviews, only: [:index, :new, :create]
  end
  # toggle to product's active status
  patch "/products/:id/toggle_active", to: "products#toggle_active", as: "product_active"
  post "products/:id/reviews", to: "reviews#create", as: "create_review"

  # Merchant
  resources :merchants, only: [:index]
  get "merchants/:merchant_id", to: "merchants#account", as: "account"
  get '/merchants/:merchant_id/orders', to:  'merchants#orders', as: 'merchant_orders'
  get '/merchants/:merchant_id/orders/:status', to:  'merchants#orders', as: 'merchant_orders'
  patch '/merchants/:merchant_id/orders/:id', to: 'order_items#ship', as: "ship"
  get '/merchants/:merchant_id/products', to: 'merchants#shop', as: 'merchant_shop'
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  put "/logout", to: "merchants#logout", as: "logout"


  # Cart + Order  
  post 'products/:id', to: 'order_items#create', as: 'add_order_item'
  get '/cart/order_items/:id', to: 'order_items#edit', as: 'order_item'
  patch '/cart/order_items/:id', to: 'order_items#update'
  delete '/cart/order_items/:id', to: 'order_items#destroy'
  get '/cart', to: "orders#cart", as: "cart"
  patch '/cart', to: "orders#clear_cart"
  get '/cart/checkout', to: "orders#checkout", as: "checkout"
  patch '/cart/checkout', to: "orders#submit_order"
  get '/orders/:id', to: "orders#show_complete", as: "complete_order"
  post '/orders/:id', to: "orders#cancel"
end

# Rails.application.routes.draw do
#   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
#   #TODO make sure to clean routes that we don't need!!!!!!!
#   resources :categories
#   get 'homepages/index'

#   root to: "homepages#index"
#   resources :products do
#     resources :reviews
#   end

# #custom route for the review creation
#  post "products/:id/reviews/new", to: "reviews#create", as: "create_review"
#   # resources :reviews , only: [:index]

#   # Merchant
#   get '/merchants', to: 'merchants#index', as: 'merchants'
#   get 'merchants/:id', to: "merchants#account", as: 'account'
#   get '/merchants/:merchant_id/orders', to: 'orders#index', as:'merchant_orders'
#   get '/merchants/:merchant_id/products', to: 'merchants#shop', as: 'merchant_products'
#   # post '/merchants/:merchant_id/products', to: 'products#create'
#   # oauth
#   get "/auth/github", as: "github_login"
#   get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
#   put "/logout", to: "merchants#logout", as: "logout"

#   # Products
#   resources :product 
#   # get    '/products', to: 'products#index', as:		'products' 
#   # get    '/products/new', to: 'products#new', as:		'new_product' 
#   # get    '/products/:id/edit', to: 'products#edit', as:		'edit_product' 
#   # get    '/products/:id', to: 'products#show', as:		'product' 
#   # patch  '/products/:id', to: 'products#update'
#   # delete '/products/:id', to: 'products#destroy'
#   patch '/products/:id/toggle_active', to: 'products#toggle_active', as: 'product_active'

#   # Cart/Order
#   post 'products/:id', to: 'order_items#create', as: 'add_order_item'
#   get '/cart/order_items/:id', to: 'order_items#edit', as: 'order_item'
#   patch '/cart/order_items/:id', to: 'order_items#update'
#   delete '/cart/order_items/:id', to: 'order_items#destroy'
#   get '/cart', to: "orders#cart", as: "cart"
#   patch '/cart', to: "orders#clear_cart"
#   get '/cart/checkout', to: "orders#checkout", as: "checkout"
#   patch '/cart/checkout', to: "orders#submit_order"
#   get '/orders/:id', to: "orders#show_complete", as: "complete_order"
#   post '/orders/:id', to: "orders#cancel"

# end

