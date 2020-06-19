class OrdersController < ApplicationController
  def show
    @order_items = OrderItem.where(order_id: @current_order.id)

    # @order_items = Order.order_items
  end

# TODO: is create method necessary??
  # def create
  #   if @current_order.nil?
  #     @current_order = Order.new
  #   end
  # end

  def edit
    if @current_order.nil?
      flash[:error] = "Order does not exist"
      return redirect_to root_path
    elsif params[:id].to_i != @current_order.id
      flash[:error] = "You can't edit an order that isn't yours"
      return redirect_to root_path
    end
  end

  def update
    if @current_order.nil?
      flash[:error] = "No current order to update"
      return redirect_to root_path
    elsif @current_order.update(order_params)
      flash[:success] = "Order ##{@current_order.id} successfully updated"
      redirect_to finalize_order_path

      return
    else
      flash[:error] = "#{@current_order.errors.messages}"
      redirect_to edit_order_path(@current_order.id)
      return
    end
  end

  def cancel_order
    if @current_order
      @current_order.order_status = "cancelled"
      @current_order.save
      session[:order_id] = nil
      flash[:succes] = "Order succesfully cancelled"
      # binding.pry
      redirect_to root_path
      return
    end
  end

  def finalize
    if @current_order.nil?
      flash[:error] = "Order does not exist"
      return redirect_to root_path
    elsif params[:id].to_i != @current_order.id
      flash[:error] = "You can't finalize an order that isn't yours"
      return redirect_to root_path
    end
    @order_items = OrderItem.where(order_id: @current_order.id)
  end

  def place_order
    if @current_order
      @current_order.order_items.each do |order_item|
        if !order_item.is_in_stock
          flash[:error] = "Not enough inventory."
          redirect_to order_path(@current_order)
          return
        end
      end

      @current_order.order_items.each do |order_item|
        product = Product.find_by(id: order_item.product_id)
        product.decrease_inventory(order_item.quantity)
        product.save
      end

      @current_order.order_status = "paid"
      @current_order.set_status_of_order_items_to_paid
      @current_order.save
      session[:order_id] = nil
      redirect_to confirm_order_path
    end
  end

  def confirmation
    @order = Order.find_by(id: params[:id])
    @order_items = OrderItem.where(order_id: @order.id)
  end

  private

  def order_params
    return params.require(:order).permit(:email_address, :mailing_address, :name_on_credit_card, :credit_card_number, :credit_card_expiration, :credit_card_CVV, :billing_zip_code)
  end
end
