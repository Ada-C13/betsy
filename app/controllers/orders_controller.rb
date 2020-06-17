class OrdersController < ApplicationController
  before_action only: [:index, :checkout, :complete] do
    find_order
  end
  
  def index
    @order_items = @current_order.order_items if @current_order
  end

  def show
    @order = Order.find_by(id: params[:id])
  
    if !@order  
      flash[:status] = :failure
      flash[:result_text] = "Sorry, there is no such order"
      redirect_to root_path
      return
    else
      # User can't see the order if any item or the order does not belong to this logged-in user's products 
      # or if there is no logged-in merchant and it's not their order
      # we need session[:order_id] or session[:merchant_id] in order to view the show page
      if session[:merchant_id] && !@order.find_merchants_ids.include?(session[:merchant_id])
        flash[:status] = :failure
        flash[:result_text] = "This order does not have your products"
        redirect_to root_path
        return
      elsif !session[:merchant_id] && session[:order_id] != @order.id
        flash[:status] = :failure
        flash[:result_text] = "You cannot view this order!"
        redirect_to root_path
        return
      end
    end
  end

  def checkout
    if !@current_order || @current_order.order_items.empty?
      flash[:status] = :failure
      flash[:result_text] = "You cannot check out without any products in your cart!"
      redirect_to cart_path
      return
    end
  end

  def complete
    # saves user info to order
    if @current_order.update(order_params)

      # change status to paid and sets purchase_date
      @current_order.update(
        status: "paid", 
        purchase_date: Date.today
      )
      
      # reduces the stock of each product 
      # TODO: Move this into a product model method
      @current_order.order_items.each do |item|
        item.product.update(stock: item.product.stock - item.quantity)
      end

      # display flash messages and redirect
      flash[:status] = :success
      flash[:result_text] = "Thank you for your order, #{@current_order.name}!"
      redirect_to order_confirmation_path(@current_order)
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not complete order!"
      flash.now[:messages] = @current_order.errors.messages
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

  def search_form
    @order = Order.new
  end

  def search
    @order = Order.search(params)

    if !@order
      flash.now[:status] = :failure
      flash.now[:result_text] = "Order not found! Please confirm your order number and email, then try again."
      render :search_form, status: :not_found
      return
    else
      flash[:status] = :success
      flash[:result_text] = "Order found! Here are the details."
      redirect_to orders_found_path(@order)
      return
    end
  end

  def found
    @order = Order.find_by(id: params[:id])
    head :not_found if !@order
    return
  end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :cc_number, :cc_exp, :cvv, :zipcode)
  end
end
