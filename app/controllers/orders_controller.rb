class OrdersController < ApplicationController

  before_action :status_from_order, except: [:index, :new, :create]

  def index
    # TODO should index list orders by customer and by merchant, do I need two indexes?
    # who is logged? anonymous, user or merchant? orders only for the merchants that is logged in
    @orders = Order.all
  end
  
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order_status = @order.status
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created order #{@order.id}"
      redirect_to order_path(@order)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create order"
      flash[:messages] = @order.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    # TODO should orderitem be sorted? sorted by status
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

  def complete # pay complete cancel
    flash[:status] = :failure
    if @login_user
      vote = Vote.new(user: @login_user, order: @order)
      if vote.save
        flash[:status] = :success
        flash[:result_text] = "Successfully upvoted!"
      else
        flash[:result_text] = "Could not upvote"
        flash[:messages] = vote.errors.messages
      end
    else
      flash[:result_text] = "You must log in to do that"
    end

    redirect_back fallback_location: order_path(@order)
  end

  private

  def order_params
    # TODO update with Orders params
    params.require(:order).permit(:title, :status, :creator, :description, :publication_year)
  end

end