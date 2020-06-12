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

  def current_merchant
    @current_merchant ||= session[:merchant_id] &&
    Merchant.find_by(id: session[:merchant_id])
  end

  def require_login
    if current_merchant.nil?
      redirect_to root_path
      flash[:danger] = "Must be logged in as a merchant."
      return
    end
  end

  def require_ownership

    if params[:id].to_i != current_merchant.id
      if request.get?
        redirect_to dashboard_merchant_url(current_merchant.id)
        flash[:warning] = "Tried to access a resource that isn't yours."
        return
      else
        redirect_back(fallback_location: root_path)
        flash[:danger] = "Could not post that request with invalid credentials."
        return
      end
    end

  end

end
