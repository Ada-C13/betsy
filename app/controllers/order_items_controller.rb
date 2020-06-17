class OrderItemsController < ApplicationController
  skip_before_action :require_login, except: [:ship]
  before_action :find_order_item, only: [ :edit, :update, :destroy, :ship]

  def create
    qty = params[:quantity].to_i
    product = Product.find_by(id: params[:id])
    # if product.stock == 0
    #   flash[:error] = "#{product.zero_inventory}"
    #   redirect_to product_path(product)
    #   return
    # elsif product.stock < qty
    #   flash[:error] = "There are only #{product.stock} #{product.name} in stock, please select another quanity."
    #   redirect_to product_path(product)
    #   return 
    # else
    #   product.decrease_quantity(qty)
    # end
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
    qty = order_item_params[:quantity].to_i
    if @order_item.product.stock == 0
      flash[:error] = "#{@order_item.product.zero_inventory}"
    elsif  @order_item.product.stock < qty
      flash[:error] = "There are only #{@order_item.product.stock} #{@order_item.product.name} in stock, please select another quanity."
    elsif @order_item.update(order_item_params)  
      flash[:success] = "Changed quantity to #{@order_item.quantity}."
    else
      flash.now[:error] = "Couldn't change quantity."
      render :edit
      return
    end
    redirect_to cart_path
    return
  end
  
  def ship
    @order_item.ship
    flash[:success] = "Notified customer that #{@order_item.product.name} has been shipped."
    redirect_to merchant_orders_path(merchant_id: session[:merchant_id])
  end

  def destroy
    order.product.increase_quantity(@order.quantity)
    @order.destroy
  end

  private
  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
