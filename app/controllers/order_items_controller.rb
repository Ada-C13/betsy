class OrderItemsController < ApplicationController
  def create
    @order_item = OrderItem.new(order_id: session[:order_id], product_id: params[:id], quantity: 1)
    if @order_item.save
      flash[:success] = "Saved to shopping cart"
    else
      flash[:warning] = 'Unable to save to shopping cart'
      flash[:details] = @order_item.errors.full_messages
    end
    redirect_back fallback_location: products_path(@order_item)
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.destroy
    redirect_to cart_path
  end
end
