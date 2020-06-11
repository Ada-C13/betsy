class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :find_order

  def render_404
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

end
