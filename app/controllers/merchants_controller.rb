class MerchantsController < ApplicationController
  skip_before_action :require_login, except: [:dashboard]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      head :not_found
      return
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
  
    if merchant
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    return redirect_to root_path
  end
  

  def dashboard

    if session[:user_id].nil?
      flash[:error] = "You must be logged in to view this page!"
    # elsif session[:user_id] != params[:uid]
    #   flash[:error] = "You are not authorized to view this page"
    else
      @merchant = Merchant.find_by(id: session[:user_id], provider: "github")
      @total_revenue = @merchant.total_revenue
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:id, :username, :email, :uid, :provider)
  end

end
