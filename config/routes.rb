Rails.application.routes.draw do
  # get 'categories/index'
  # get 'categories/new'
  get 'merchants/index'
  get 'merchants/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :categories, only: [:index, :show, :create]
end
