class OrdersController < ApplicationController
  before_action only: [:show, :update, :destroy] do
    find_order(params[:id])
  end
  
  def index
    # shows all order_items that match session[:order_id]
  end

  def show
  end

  def checkout
    @order = Order.find_by(id: session[:order_id]) # passing in the order that matches session[:order_id], because this route does not have an id params
    head :not_found if !@order
    return
  end

  def update
    # saves user info to order
    # changes status to paid
    # session[:order_id] = nil
    # redirects to order show page
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
