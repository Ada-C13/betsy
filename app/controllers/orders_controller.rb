class OrdersController < ApplicationController

  before_action :get_order, except: [:index, :new, :create]
  
  def index
    @orders = Order.all.order(:status)
  end
  
  def show
    @order = Order.find_by(id: params[:id])
  end

  def edit
  end

  def update
    if @shopping_cart.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated shopping cart."
      redirect_back fallback_location: order_path(@shopping_cart)      
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

  def pay
    if @shopping_cart.checkout_order!
      session[:order_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully paid order #{@shopping_cart.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Payment processing failed!"
    end
    redirect_to order_path(@shopping_cart)
  end

  def complete
    order = Order.find_by(id: params[:id])
    if order.ship_order!
      flash[:status] = :success
      flash[:result_text] = "Successfully completed order #{order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to complete the order."
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

  def get_order
    @shopping_cart = Order.find_by(id: params[:id])
    render_404 unless @shopping_cart
  end  

end
