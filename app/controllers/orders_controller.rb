class OrdersController < ApplicationController
  
  before_action :require_login, only: [:index, :show]
  before_action :find_order, only: [:show, :complete, :cancel, :confirmation]

  def index
    # List orders for a Merchant (Merchant only)
    @orders = Order.by_merchant(current_merchant)
  end
  
  def show
    # Shows any orders from the Merchant (Merchant only)
  end

  def edit
    # Shows cart, updates credit card/address/email and confirms checkout (User)
  end

  def update
    # Process checkout, changes status to “paid”, show confirmation (User)
    @shopping_cart.time_submitted = DateTime.now
    if @shopping_cart.update(order_params)
      if @shopping_cart.checkout_order!
        session[:order_id] = nil
        flash[:success] = "Successfully checked out order #{@shopping_cart.id}"
        redirect_to order_confirmation_path(@shopping_cart)
      else
        flash[:warning] = "Checkout has failed!"
        flash[:details] = @shopping_cart.errors.full_messages
        render :edit, status: :bad_request
      end
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Please enter required info before checkout."
      flash.now[:messages] = @shopping_cart.errors.full_messages
      render :edit, status: :bad_request
    end
  end

  def destroy
    # Empties cart (User)
    @shopping_cart.destroy
    session[:order_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully emptied shopping cart."
    redirect_to root_path
  end

  def complete
    # Ships the order, changes status to “complete” (Merchant only)
    if @order.ship_order!
      flash[:success] = "Successfully completed order #{@order.id}"
    else
      flash[:warning] = "Failed to complete order #{@order.id}."
      flash[:details] = @order.errors.full_messages
    end
    redirect_back fallback_location: order_path(@order)      
  end

  def cancel
    # Cancels the order, changes status to “cancelled” (Merchant only)
    if @order.cancel_order!
      flash[:status] = :success
      flash[:result_text] = "Successfully cancelled order #{@order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to cancel order."
    end
    redirect_back fallback_location: order_path(@order)      
  end

  def confirmation
    # Shows order confirmation after checkout (User)
  end

  private

  def order_params
    params.require(:order).permit(
      :status, :name, :credit_card_num,
      :credit_card_exp, :credit_card_cvv,
      :address, :city, :state, :zip,
      :time_submitted, :customer_email
    )
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    if !@order
      flash[:status] = :failure
      flash[:result_text] = "Could not find order." 
      redirect_to orders_path      
    end
  end

end
