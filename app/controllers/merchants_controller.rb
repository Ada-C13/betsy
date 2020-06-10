class MerchantsController < ApplicationController

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    
    if merchant 
      flash[:success] = "Logged in as returning user"
    else 
      merchant = Merchant.create_merchant_from_github(auth_hash)
      if merchant.save 
        #flash
      else
        flash[:error] = "Could not create new user account"
        return redirect_to root_path
        
      end
    end 
    session[:user_id] = user.id
    redirect_to root_path
  end

end
