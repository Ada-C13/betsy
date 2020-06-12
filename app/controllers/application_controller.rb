class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :find_order

  before_action :current_merchant
  #before_action :require_login

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  private

  def find_order
    if session[:order_id]
      @shopping_cart = Order.find_by(id: session[:order_id])
    else
      @shopping_cart = Order.create(status: "pending")
      session[:order_id] = @shopping_cart.id
    end 
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to login_path
    end
  end

  def current_merchant
    if session[:merchant_id]
      @current_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end
end
