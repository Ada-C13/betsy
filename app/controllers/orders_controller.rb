class OrdersController < ApplicationController
  
  before_action :require_login, only: [:index, :show]
  
  def index
    @orders = Order.by_merchant(current_merchant)
  end
  
  def show
    @order = Order.find_by(id: params[:id])
    if !@order
      flash[:status] = :failure
      flash[:result_text] = "Could not find order."
      redirect_to orders_path      
    end
  end

  def edit
    # shows shopping cart
  end

  def update
    if @shopping_cart.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated shopping cart."
      redirect_to cart_path      
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update shopping cart."
      flash.now[:messages] = @shopping_cart.errors.messages
      render :edit, status: :not_found
    end
  end

  def destroy
    @shopping_cart.destroy
    session[:order_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully emptied shopping cart."
    redirect_to root_path
  end

  def checkout
    @shopping_cart.update(order_params)
    if @shopping_cart.checkout_order!
      session[:order_id] = nil
      flash[:success] = "Successfully paid order #{@shopping_cart.id}"
      redirect_to order_path(@shopping_cart)
    else
      flash[:warning] = "Payment processing failed!"
      flash[:details] = @shopping_cart.errors.full_messages
      render :edit
    end
  end

  def complete
    order = Order.find_by(id: params[:id])
    if order.ship_order!
      flash[:success] = "Successfully completed order #{order.id}"
    else
      flash[:warning] = "Failed to complete the order."
      flash[:details] = order.errors.full_messages
    end
    redirect_back fallback_location: order_path(order)      
  end

  def cancel
    order = Order.find_by(id: params[:id])
    if order.cancel_order!
      flash[:status] = :success
      flash[:result_text] = "Successfully cancelled order #{order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to cancel order."
    end
    redirect_back fallback_location: order_path(order)      
  end

  private

  def order_params
    params.require(:order).permit(:status,
      :credit_card_num, :credit_card_exp, :credit_card_cvv,
      :address, :city, :state, :zip,
      :time_submitted, :customer_email
    )
  end

end
