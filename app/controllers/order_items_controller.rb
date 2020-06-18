class OrderItemsController < ApplicationController
  def create
    product_id = params[:id]
    order_item_params = params[:order_item]
    if order_item_params.nil?
      quantity = 1
    else
      quantity = params[:order_item][:quantity].to_i
    end
    message = OrderItem.add_item(@shopping_cart.id, product_id, quantity)
    if message.nil?
      flash[:success] = "Product added to shopping cart"
    else
      flash[:warning] = "Unable to add product to shopping cart"
      flash[:details] = [message]
    end
    redirect_back fallback_location: cart_path
  end

  def update
    order_item = OrderItem.find_by(id: params[:id])
    if order_item
      quantity = params[:order_item][:quantity].to_i
      message = order_item.update_item(quantity)
      if message.nil?
        flash[:success] = "Product quantity updated"
      else
        flash[:warning] = "Unable to update product quantity"
        flash[:details] = [message]
      end
      redirect_to cart_path
    else
      flash[:warning] = "Item in cart does not exist"
      redirect_to cart_path, :status => 304
    end
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])
    if !@order_item
      flash[:warning] = "Unable to find item in shopping cart"
      redirect_back fallback_location: cart_path
      return
    end
    message = @order_item.remove_item
    if message.nil?
      flash[:success] = "Product removed from shopping cart"
    else
      flash[:warning] = "Unable to remove product from shopping cart"
      flash[:details] = [message]
    end
    redirect_back fallback_location: cart_path
  end
end
