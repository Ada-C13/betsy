class MerchantsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :destroy, :show, :index]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # Merchant was found in the database
      flash[:success] = "Logged in as returning: #{merchant.username}"
    else
      # Merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as: #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant instance

    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  def current
    @merchant = Merchant.find_by(id: session[:merchant_id])
    @order_items = OrderItem.by_merchant(session[:merchant_id])

    if status_param != "all"
      @status = status_param
      @order_items = @merchant.orders_by_status(status_param)
    end

    if @merchant.nil?
      # I have to be logged in!
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
      return
    end
  end

  private
  
  def status_param
    params.permit(:status)[:status] || "all"
  end
  
end
