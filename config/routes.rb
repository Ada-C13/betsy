Rails.application.routes.draw do
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
