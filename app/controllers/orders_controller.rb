class OrdersController < ApplicationController

  before_action :get_order, except: [:index, :new, :create]
  
  def index
    @orders = Order.all.order(:status)
  end
  
  def new
    @order = Order.new(status: "pending")
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created order #{@order.id}"
      redirect_to order_path(@order)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not create order"
      flash.now[:messages] = @order.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @orderitems = @order.orderitems
  end

  def edit
  end

  def update
    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order #{@order.id}"
      redirect_to order_path(@order)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update order"
      flash.now[:messages] = @order.errors.messages
      render :edit, status: :not_found
    end
  end

  def destroy
    @order.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully destroyed order #{@order.id}"
    redirect_to root_path
  end

  def pay
    if @order.process_payment
      flash[:status] = :success
      flash[:result_text] = "Successfully paid order #{@order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Payment processing failed!"
    end
    redirect_to order_path(@order)
  end

  def complete
    if @order.complete_order
      flash[:status] = :success
      flash[:result_text] = "Successfully completed order #{@order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to complete the order."
    end
    redirect_to order_path(@order)
  end

  def cancel
    if @order.cancel_order
      flash[:status] = :success
      flash[:result_text] = "Successfully cancelled order #{@order.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to cancel order."
    end
    redirect_to order_path(@order)
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
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end  

end