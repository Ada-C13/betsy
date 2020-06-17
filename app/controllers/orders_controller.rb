class OrdersController < ApplicationController
  
  before_action :find_order, only: [:show, :complete, :cancel, :confirmation]

  def edit
    # Shows cart, updates credit card/address/email and confirms checkout (User)
  end

  def update
    # Process checkout, changes status to “paid”, show confirmation (User)
    @shopping_cart.time_submitted = DateTime.now
    if @shopping_cart.update(order_params)
      result = @shopping_cart.checkout_order!
      if result.nil?
        session[:order_id] = nil
        flash[:success] = "Successfully checked out order #{@shopping_cart.id}"
        redirect_to order_confirmation_path(@shopping_cart)
      else
        flash[:warning] = "Checkout has failed: #{result}"
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
    result = @order.ship_order!
    if result.nil?
      flash[:success] = "Successfully completed order #{@order.id}"
    else
      flash[:warning] = "Failed to complete order #{@order.id}: #{result}"
      flash[:details] = @order.errors.full_messages
    end
    redirect_back fallback_location: order_path(@order)      
  end

  def cancel
    # Cancels the order, changes status to “cancelled” (Merchant only)
    result = @order.cancel_order!
    if result.nil?
      flash[:status] = :success
      flash[:result_text] = "Successfully cancelled order #{@order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to cancel order: #{result}"
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
