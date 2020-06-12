class MerchantsController < ApplicationController
  before_action :require_login, only: [:dashboard, :logout]
  before_action :ownership, only: [:dashboard, :manage_orders, :manage_products]

  def show
    @merchant = Merchant.find(params[:id])

    if @merchant.nil?
      head :not_found
      return
    end
  end

  def login #create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # User was found in the database
      flash[:success] = "Logged in as returning user #{merchant.username}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      merchant = Merchant.build_from_github(auth_hash)
     
      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
    
      else
       
        flash[:error] = "Could not create new user account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant's instance
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def dashboard
    
  end

  def manage_orders

  end

  def manage_products

  end

  def logout
    session.delete(:merchant_id)
    redirect_to root_path
    flash[:success] = "Successfully logged out!"
  end

  private 

  def ownership
    if params[:id].to_i != @current_merchant.id
      redirect_to root_path
      flash[:danger] = "Wrong merchant resource, accessing #{params[:id]} but you're #{@current_merchant.id}."
    end
  end

  
end
