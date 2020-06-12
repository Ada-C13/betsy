Rails.application.routes.draw do
  get 'homepages/index'
  get 'categories/index'
  get 'categories/new'
  get 'merchants/index'
  get 'merchants/show'


  root to: "homepages#index"
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
