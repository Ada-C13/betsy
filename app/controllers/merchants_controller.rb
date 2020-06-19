class MerchantsController < ApplicationController
  
  def dashboard
    if @current_merchant.nil?
      flash[:error] = "Must be logged in to view Merchant dashboard"
      redirect_to root_path
      return
    end

    @status = status_param

    # create instance variables of the current merchant to be displayed 
    if @status == "all"
      @orders = @current_merchant.get_all_orders
    else
      @orders = @current_merchant.get_orders_by_status(@status)
    end 
    
    all_orders = @current_merchant.get_all_orders
    paid_orders = @current_merchant.get_orders_by_status("paid")
    completed_orders = @current_merchant.get_orders_by_status("complete")

    @paid_orders_revenue = @current_merchant.total_revenue(paid_orders)
    @completed_orders_revenue = @current_merchant.total_revenue(completed_orders)
    @total_revenue = @current_merchant.total_revenue(all_orders)
  end 

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
   
    if merchant 
      flash[:success] = "Logged in as returning user"
    else 
      merchant = Merchant.create_merchant_from_github(auth_hash)
      if merchant.save 
        flash[:status] = "Merchant account created"
      else
        flash[:error] = "Could not create new user account"
        return redirect_to github_login_path
      end
    end 

    # store logged in user in session
    session[:user_id] = merchant.id

    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:status] = "Successfully logged out!"

    redirect_to root_path
  end

  def merchant_products
    @merchant = Merchant.find_by_id(params[:merchant_id])
    @merchant_products = @merchant.products 
  end

  private
  def status_param
    params.permit(:status)[:status] || "all" 
  end 
end
