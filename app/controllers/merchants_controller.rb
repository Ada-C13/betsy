class MerchantsController < ApplicationController
  before_action :require_login, only: [:dashboard, :manage_orders, :manage_products, :logout]
  before_action :require_ownership, only: [:dashboard, :manage_orders, :manage_products]

  def login 
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:success] = "Welome back #{merchant.username}!"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:merchant_id] = merchant.id
    return redirect_to dashboard_merchant_url(merchant)
  end

  def dashboard; end

  def manage_orders; end

  def manage_products; end

  def logout
    session.delete(:merchant_id)
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end
end
