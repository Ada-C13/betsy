class OrdersController < ApplicationController
  before_action :find_cart, only: [ :submit_order, :checkout ]
  before_action :find_order, only: [ :show_complete, :cancel]

  def cart
    if session[:cart_id]
      @order = Order.find_by(id: session[:cart_id])
    else
      @order = Order.new
      if @order.save
        session[:cart_id] = order.id
      else
        flash[:error] = "Oops, something went wrong. Product could not be added to cart."
      end
    end
  end

  def checkout; end

  def submit_order
    if @order.update(order_params)
      #@order.change_status("paid")
      @order.status = "paid"
      session[cart_id] = nil
      flash[:success] = "Your order has been submitted!"
      redirect_to complete_order_path(@order)
      return
    else
      flash.now[:error] = "Woops, #{order.error.messages}"
      render :checkout
      return
    end
  end

  def show_complete; end

  def cancel
    @order.cancel
    flash[:success] = "Your order was cancelled."
    redirect_to root_path
    return
  end

  private
  def find_cart
    @order = Order.find_by(id: session[cart_id])
    if @order.nil?
      head :not_found
      return
    end
  end

  def find_order
    @order = Order.find_by(id: params[:id])    if @order.nil?
      head :not_found
      return
    end
  end

  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_last_four, :cc_exp, :cc_cvv)
  end

end
