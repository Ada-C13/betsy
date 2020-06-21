class ApplicationController < ActionController::Base
  before_action :set_categories, :set_current_order, :current_user

  def set_categories
    @categories = Category.all
  end

  def set_current_order
    @order = Order.find_by(id: session[:order_id])

    unless @order && @order.status == "pending"
      # create new order 
      @order = Order.new(status: "pending")
      unless @order.save
        flash[:status] = :failure
        flash[:result_text] = "Couldn't create order, try again later"
        flash[:messages] = order.errors.messages
        return
      end

      session[:order_id] = @order.id
    end
  end

  def current_user
    @current_user = Merchant.find_by(id: session[:merchant_id])
  end

  def require_login
    if current_user.nil?
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)
    end
  end
end
