Rails.application.routes.draw do
  get '/cart', to: "orders#cart", as: "cart"
  get '/cart/checkout', to: "orders#checkout", as: "checkout"
  post '/cart/checkout', to: "orders#submit_order"
  get '/orders/:id', to: "orders#show_complete", as: "complete_order"
  post '/orders/:id', to: "orders#cancel"


  get 'categories/index'
  get 'categories/new'
  get 'merchants/index'
  get 'merchants/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
