Rails.application.routes.draw do
  root 'homepages#index'

resources :merchants # to be changed later

 # Omniauth Login route
 get "/auth/github", as: "github_login"

 # Omniauth Github callback route
 get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"
 

end
