class OrderItemsController < ApplicationController

  def create
    qty = params[:order_item][:quantity]
    product = Product.find_by(id: params[:id])
    order = nil
    order_item = OrderItem.new(order_item_params)
    if session[:cart_id]
      order = Order.find_by(id: session[:cart_id])
      existing_order_item = order.find_order_item(product)
      if existing_order_item
        existing_order_item.quantity += qty
        flash[:success] = "Added additional #{qty} to cart."
        redirect_to product_path(product)
        return
      end
      order_item.order = order
    else # new cart
      order = Order.create
      session[:cart_id] = order.id
    end
    order_item.product = product
    order_item.order = order
    if order_item.save
      flash[:success] = "Added #{qty} of #{product.name} to cart."
    else
      flash[:error] = "Unable to add #{qty} of #{product.name} to cart"
    end
    redirect_to product_path(product)
    return
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private
  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end
end
