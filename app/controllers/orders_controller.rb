class OrdersController < ApplicationController
  before_action only: [:index, :checkout, :complete, :destroy] do
    find_order(session[:order_id])
  end
  
  def index
    @order_items = @order.order_items if @order
  end

  def show
    @order = Order.find_by(id: params[:id])

    if !@order || @order.id != session[:order_id] # we need session[:order_id] in order to view the show page
      flash[:status] = :failure
      flash[:result_text] = "You cannot view this order!"
      redirect_to root_path
      return
    elsif @order.status == "paid" # if the order has been completed, we will reset the session[:order_id]
      session[:order_id] = nil
    end
  end

  def checkout
    if @order
      @order.update(status: "pending")
    elsif !@order || @order_items.empty?
      flash[:status] = :failure
      flash[:result_text] = "You cannot check out without any products in your cart!"
      redirect_to cart_path
      return
    end
  end

  def complete
    # saves user info to order
    if @order.update(order_params)

      # stores the last 4 digits of cc_number
      @order.update(cc_number: @order.cc_number.to_s[-4..-1].to_i) 

      # reduces the stock of each product 
      # QUESTION: Should this be moved into a product model method?
      @order.order_items.each do |item|
        item.product.update(stock: item.product.stock - item.quantity)
      end
      
      # change status to paid
      @order.update(status: "paid")

      # display flash messages and redirect
      flash[:status] = :success
      flash[:result_text] = "Thank you for your order, #{@order.name}!"
      redirect_to order_path(@order)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not complete order!"
      flash.now[:messages] = @order.errors.messages
      render :checkout, status: :bad_request
      return
    end
  end

  def destroy
    # destroys order (need dependent: destroy in model to also destroy associated order_items)
    # session[:order_id] = nil
  end

  private

  def find_order(id)
    @order = Order.find_by(id: id)
  end

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :cc_number, :cc_exp)
  end
end
