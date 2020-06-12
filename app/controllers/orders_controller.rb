class OrdersController < ApplicationController
  before_action only: [:show, :checkout, :update, :destroy] do
    find_order(session[:order_id])
  end
  
  # def index
  #   @order_items = OrderItems.where(id: session[:order_id])
  # end

  def show
  end

  def checkout
  end

  def update
    # saves user info to order
    # reduces the stock of each product
    # changes status to pending
    # session[:order_id] = nil
    # redirects to checkout finalize page, which needs a route
  end

  def destroy
    # destroys order (need dependent: destroy in model to also destroy associated order_items)
    # session[:order_id] = nil
  end

  private

  def find_order(id)
    @order = Order.find_by(id: id)
    head :not_found if !@order
    return
  end

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :cc_number, :cc_exp) # TODO: Do we want to store CVV and billing zip even if we're not showing it?
  end
end
