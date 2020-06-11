Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/new'
  get 'merchants/index'
  get 'merchants/show'

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create" as: "omniauth_callback"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
