class MerchantsController < ApplicationController

  skip_before_action :require_login, except: [:account]

  def index
    @merchants = Merchant.all
  end

  def account
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil? || session[:merchant_id] != @merchant.id
      flash[:error] = "You don't have access to that account!"
      redirect_to account_path(session[:merchant_id])
      return
    end
  end


  def create
    auth_hash = request.env["omniauth.auth"]
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

  private

  def merchant_params
    return params.require(:merchant).permit(:name, :email, :provider, :uid)
  end
end