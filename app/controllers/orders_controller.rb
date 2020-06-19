class OrdersController < ApplicationController

  before_action :find_order, only: [:manage, :edit, :status, :update, :cancel_order, :complete_order]
  skip_before_action :require_login, only: [:index, :create, :show, :edit, :update, :status]

  def index
    @orders = Order.all
  end

  def create
    if session[:order_id]

      @order = Order.new(order_params)
    else
      @order = Order.new

      session[:order_id] = @order.id
    end

    if @order.save
      # sets the session order id
      session[:order_id] = @order.id
      flash[:success] = "Successfully created order"
      return redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not create order"
      return redirect_to root_path
    end
  end

  def show
    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      flash[:error] = "You haven't started an order yet. Add some items to your cart first!"
      redirect_to products_path
      return
    else
      # Use current order if there is already one:
      order_id = session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      @order_products = OrderItem.by_order_id(order_id)
    end
  end

  def manage
  end

  def edit
    order_items = @order.order_items
    
    inventory_errors = 0
    order_items.each do |order_item|
      if order_item.quantity > order_item.product.inventory
        if order_item.product.inventory == 0
          order_item.destroy
        else
          order_item.quantity = order_item.product.inventory
          order_item.save
        end
        inventory_errors += 1
      end
    end

    if inventory_errors > 0
      flash[:error] = "Some of the items in your cart are no longer in stock. We have updated your cart to reflect the current quantity."
      redirect_to order_path(params[:id])
      return
    end
  end

  def status
  end

  def update
    if @order.status == "paid"
      flash[:error] = "This order has already been confirmed and can no longer take changes."
      redirect_to orders_path
      return
    end

    if @order.order_items.empty?
      flash[:error] = "You don't have any items in your cart. Add some items to your cart first!"
      redirect_to products_path
      return
    elsif @order.update(order_params)
      @order.order_purchase
      # clear session order id
      session[:order_id] = nil
      flash[:success] = "Successfully made an order #{@order.id}"

      redirect_to status_path(@order.id)
      return
    else
      flash.now[:error] = "We cannot proceed this order. Sorry!"
      render :edit
      return
    end
  end

  def cancel_order
    @order.cancel_order_inventory

    return redirect_to current_merchant_path
  end

  def complete_order
    @order.status = "complete"
    @order.save!

    flash[:success] = "Successfully made an order #{@order}"
    return redirect_to current_merchant_path
  end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :credit_card, :credit_card_exp, :status)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "You haven't started an order yet. Add some items to your cart first!"
      redirect_to products_path
      return
    end
  end
end
