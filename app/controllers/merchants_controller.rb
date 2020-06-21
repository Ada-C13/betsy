class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
    @url = "http://thecatapi.com/api/images/get?format=src&type=gif&timestamp="
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    @url = "http://thecatapi.com/api/images/get?format=src&type=gif&timestamp="

    if @merchant.nil?
      return head :not_found
    end 
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    
    if merchant
      flash[:result_text] = "Did you get lost in the woods? We missed you, #{merchant.username}"  
    else
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:result_text] = "Welcome to the great Outdoorsy, #{merchant.username}." 
      else
        flash[:result_text] = "Failure: Take a hike!"
        flash[:messages] = merchant.errors.messages
        return redirect_to root_path
      end 
    end

    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:result_text] = "Get Outdoorsy, catch ya later alligator"
    redirect_to root_path
    return
  end
end
