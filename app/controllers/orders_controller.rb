class OrdersController < ApplicationController
  # todo -product model made then collab for update order quantity
  before_action :require_login, only: [:index]
  before_action :find_order_from_session, only: [:edit, :update, :cart]
  before_action :find_order_from_params, only: [:show, :success, :cancel]

  # Renders details page for order already paid for (or cancelled?)
  # if we want other redirect behavior, edit later******
  def index
    @merchant = Merchant.find_by(id: session[:merchant_id])
    @order_collection = @merchant.all_orders
    @paid_collection = @merchant.order_status("paid")
    @complete_collection = @merchant.order_status("complete")
    @cancelled_collection = @merchant.order_status("cancelled")

    @total_revenue = @merchant.total_revenue
    @paid_revenue = @merchant.revenue_by_status("paid")
    @complete_revenue = @merchant.revenue_by_status("complete")
    @cancelled_revenue = @merchant.revenue_by_status("cancelled")
  end

  def show
    @order.mark_as_complete!
  end

  # Renders payment information form
  def edit ; end

  # Called when user tries to submit payment
  def update
    if @order.update(order_params)

      result = @order.checkout

      if result == true
        flash.now[:result_text] = "(1) Order successfully paid!"
        # redirect_back(fallback_location: root_path)
        # redirect_to order_path(@order.id)
        redirect_to success_path(id: @order.id)
        reset_session
        return
      else
        # Don't sweat testing this else block
        # render :edit, status: :bad_request
        flash[:result_text] = "Order failed to checkout."
        redirect_back(fallback_location: root_path)
        return
      end

      # redirect_to success_path(session[:order_id])
      # return
    else
      # redirect_to edit_order_path(session[:order_id])
      render :edit
    end
  end

  # Shows cart currently in progress
  def cart ; end

  # Shows confirmation page for recently placed order
  def success ; end

  # Marks order as cancelled
  def cancel
    if @order.status == "paid" && @order.orderitems.find_by(shipped: true).nil?
      @order.cancel_order
      flash[:success] = "Your order, #{ @order.id }, has been cancelled!"
      redirect_back fallback_location: root_path
    elsif @order.status == "paid" && @order.orderitems.find_by(shipped: false).nil?
      flash[:failure] = "Cannot cancel an order that has already been shipped"
      redirect_back fallback_location: root_path
    else
      flash[:failure] = "Cannot cancel this order, one or more of your items has already shipped"
      redirect_to root_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:email, :address, :cc_name, :cc_num, :cvv, :cc_exp, :zip)
  end

  def find_order_from_session
    @order = Order.find_by(id: session[:order_id])
    return head :not_found if @order.nil?
  end

  def find_order_from_params
    @order = Order.find_by(id: params[:id])
    return head :not_found if @order.nil?
  end
end
