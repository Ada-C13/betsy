class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order_item, only: [ :edit, :update, :destroy]

  def create
    qty = params[:quantity].to_i
    product = Product.find_by(id: params[:id])
    order = nil
    order_item = OrderItem.new(quantity: qty)
    if session[:cart_id]
      order = Order.find_by(id: session[:cart_id])
      existing_order_item = order.find_order_item(product)
      if existing_order_item
        flash[:redirect] = "#{product.name} already in cart. Edit quantity here:"
        redirect_to order_item_path(existing_order_item)
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

  def edit; end

  def update
    if @order_item.update(order_item_params)
      flash[:success] = "Changed quantity."
      redirect_to product_path(@order_item.product)
      return
    else
      flash.now[:error] = "Couldn't change quantity."
      render :edit
      return
    end
  end

  def destroy
  end

  private
  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
