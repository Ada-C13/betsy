class OrdersController < ApplicationController
  before_action only: [:index, :checkout, :complete] do
    find_order
  end
  
  def index
    @order_items = @order.order_items if @order
  end

  def show
    @order = Order.find_by(id: params[:id])
    head :not_found if !@order
    return
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
      # TODO: Move this into an order model method, instead of storing, we want to display the last 4
      @order.update(cc_number: @order.cc_number.to_s[-4..-1].to_i) 

      # change status to paid and sets purchase_date
      @order.update(
        status: "paid", 
        purchase_date: Date.today
      )

      # reduces the stock of each product 
      # TODO: Move this into a product model method
      @order.order_items.each do |item|
        item.product.update(stock: item.product.stock - item.quantity)
      end

      # display flash messages and redirect
      flash[:status] = :success
      flash[:result_text] = "Thank you for your order, #{@order.name}!"
      redirect_to order_confirmation_path(@order)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not complete order!"
      flash.now[:messages] = @order.errors.messages
      render :checkout, status: :bad_request
      return
    end
  end

  def confirmation
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

  def destroy
    @order = Order.find_by(id: params[:id])
    
    if !@order
      head :not_found 
      return
    else
      # TODO: Move this into a product model method
      @order.order_items.each do |item|
        item.product.update(stock: item.product.stock + item.quantity)
      end

      # sets order status to cancelled
      @order.update(status: "cancelled")

      # display flash messages and redirect
      flash[:status] = :success
      flash[:result_text] = "Order ##{@order.id} has been successfully cancelled"
      redirect_to root_path
      return
    end
  end

  def search
    # Params: order id and email address - both are required to complete the search
    # Flashes an error message if order can’t be found
    # Else flashes a success message
    # Redirects to order_path
  end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :cc_number, :cc_exp)
  end
end
