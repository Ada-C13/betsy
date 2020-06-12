class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def account
    @merchant = Merchant.find_by(id: session[:merchant_id])
    unless @merchant
      flash[:error] = "We regret to inform you that accesss to this page is restricted"
      redirect_to root_path
      return
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    # puts auth_hash
    # binding.pry
    merchant = Merchant.find_by(uid: auth_hash[:uid],
      provider: params[:provider])

    if merchant # merchant exists
      flash[:notice] = "Logged in as returning merchant #{merchant.name}"
    else # merchant doesn't exist yet (new merchant)
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:notice] = "Logged in as a new merchant #{merchant.name}"
      else
        flash[:error] = "Could not create merchant account  #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end
    session[:merchant_id] = merchant.id
    redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:notice] = "Successfully logged out. See you next time"
    redirect_to root_path
    return
  end
end