Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #TODO make sure to clean routes that we don't need!!!!!!!
  resources :categories
  get 'homepages/index'

  root to: "homepages#index"
  resources :products do
    resources :reviews
  end

#custom route for the review creation
 post "products/:id/reviews/new", to: "reviews#create", as: "create_review"
  # resources :reviews , only: [:index]

  # Merchant
  resources :merchants, only: [:index]
  get "merchants/:id", to: "merchants#account", as: "account"
  # TODO: (Ross) In order to make this nested route works, we have to wait for Lak to merge her Product controller with the "index" action 
  resources :merchants do

    # this nested route will trigger the "index" action in products controller from Lak
    # this nested route will trigger the "index" action in orders controller from Yaz
    resources :orders, only: [:index]
    resources :products, only: [:create,:index]
    # TODO: add the nested route merchants/:id/orders to show all the orders
  end
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
  put "/logout", to: "merchants#logout", as: "logout"

  # toggle to product's active status
  patch '/products/:id/toggle_active', to: 'products#toggle_active', as: 'product_active'
  
  post 'products/:id', to: 'order_items#create', as: 'add_order_item'
  get '/cart/order_items/:id', to: 'order_items#edit', as: 'order_item'
  post '/cart/order_items/:id', to: 'order_items#update'
  delete '/cart/order_items/:id', to: 'order_items#destroy'

  get '/cart', to: "orders#cart", as: "cart"
  get '/cart/checkout', to: "orders#checkout", as: "checkout"
  post '/cart/checkout', to: "orders#submit_order"
  get '/orders/:id', to: "orders#show_complete", as: "complete_order"
  post '/orders/:id', to: "orders#cancel"

end
