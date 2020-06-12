class OrderItemsController < ApplicationController
  def create
    @order_item = OrderItem.new(order_id: session[:order_id], product_id: params[:id], quantity: 1)
    if @order_item.save
      flash.now[:success] = "Saved to shopping cart"
      raise
    else
      flash.now[:warning] = 'Unable to save to shopping cart'
      flash.now[:details] = @order_item.errors.full_messages
    end
  end
end
