class OrderItemsController < ApplicationController
  def create
    message = OrderItem.add_item(@shopping_cart.id, params[:id], 1)
    if message.nil?
      flash[:success] = "Product added to shopping cart"
    else
      flash[:warning] = "Unable to add product to shopping cart"
      flash[:details] = [message]
    end
    redirect_back fallback_location: cart_path
  end

  def update_quantity
    @order_item = OrderItem.find(params[:id])
    quantity = params[:quantity].to_i
    @order_item.update_item(quantity)
    redirect_to cart_path
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    @order_item.remove_item
    redirect_to cart_path
  end
end
