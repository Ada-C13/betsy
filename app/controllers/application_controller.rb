class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :find_cart
  before_action :current_merchant

  # def render_404
  #   # DPR: this will actually render a 404 page in production
  #   raise ActionController::RoutingError.new("Not Found")
  # end

  def find_cart
    if session[:order_id]
      @shopping_cart = Order.find_by(id: session[:order_id])
      return if !@shopping_cart.nil? && @shopping_cart.status == "pending"
    end
    @shopping_cart = Order.create(status: "pending")
    session[:order_id] = @shopping_cart.id
  end

  def current_merchant
    @current_merchant ||= session[:merchant_id] &&
      Merchant.find_by(id: session[:merchant_id])
  end

  def current_product 
    @current_product ||= params[:product_id] &&
      Product.find_by(id: params[:product_id])
  end

  def require_login
    if current_merchant.nil?
      redirect_to root_path
      flash[:danger] = "Must be logged in as a merchant."
      return
    end
  end

  def require_ownership
    if params[:controller] == "merchants"
      requester = params[:id].to_i # when params id references a merchant
    else
      requester = Product.find_by(id: params[:id]).merchant.id # when params id references a product
    end 

    if requester != current_merchant.id
      if request.get? # merchant trying to GET ownership-locked resources
        redirect_to dashboard_merchant_path(@current_merchant.id)
        flash[:warning] = "Tried to access a resource that isn't yours. Returning to your dashboard."
        flash[:danger] = request.params
        return
      else
        redirect_back(fallback_location: root_path)
        flash[:danger] = "Could not complete that request with invalid credentials."
        return
      end
    end
  end
end
