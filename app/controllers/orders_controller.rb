class OrdersController < ApplicationController
  before_action only: [:index, :show, :checkout, :update, :destroy] do
    find_order(session[:order_id])
  end
  
  def index
    @order_items = @order.order_items if @order
  end

  def show
    # find order by params
    # if order.id is not equal to session[:order_id]
    # flash error message saying that you can't view this page
    # redirect to merchants path
  end

  def checkout
    if @order
      @order.update(status: "pending")
    elsif !@order || @order_items.empty?
      flash[:status] = :failure
      flash[:result_text] = "A problem occurred: You cannot check out without any products in your cart!"
      redirect_to cart_path
      return
    end
  end

  def confirm
    # saves user info to order
    # reduces the stock of each product
    # changes status to paid
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
  end

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :cc_number, :cc_exp) # TODO: Do we want to store CVV and billing zip even if we're not showing it?
  end
end
