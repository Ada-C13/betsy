class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:account, :shop, :orders]
  skip_before_action :require_login, except: [:account, :orders]

  def index
    @merchants = Merchant.all
  end

  def account
    if @merchant.nil? || session[:merchant_id] != @merchant.id
      flash[:error] = "You don't have access to that account!"
      redirect_to account_path(session[:merchant_id])
      return
    end
  end

  def shop
    # TODO: the pagination doesn't work
    @merchant_products = @merchant.products.paginate(page: params[:page], per_page: 9)
  end

  def orders
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid],
      provider: params[:provider])
    
    if merchant # merchant exists
      flash[:notice] = "Logged in as returning merchant #{merchant.name.titleize}"
    else # merchant doesn't exist yet (new merchant)
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:notice] = "Logged in as a new merchant #{merchant.name.titleize}"
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
    return params.require(:merchant).permit(:name, :email, :provider, :uid, :avatar)
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end
end