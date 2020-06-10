Rails.application.routes.draw do
  
 # Omniauth Login route
 get "/auth/github", as: "github_login"

 # Omniauth Github callback route
 get "/auth/:provider/callback", to: "merchants#create", as: "omniauth_callback"

end
