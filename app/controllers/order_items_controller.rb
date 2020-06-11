class OrderItemsController < ApplicationController
  before_action only: [:update, :destroy] do
    find_order_item(params[:id])
  end

  def create
    # creates a new order if there is no order_id saved to session
    if !session[:order_id]
      order = Order.create(status: "pending")
      session[:order_id] = order.id
    end

    # find product by the id passed in thru form
    product = Product.find_by(id: params[:product_id])
    return head :not_found if !product

    # create new order_item
    order_item = OrderItem.new(
      product_id: product.id,
      order_id: session[:order_id],
      quantity: params[:product][:quantity], # TODO: Confirm whether product is the correct key name (if the form uses the product model, this should be right)
      shipped: false
    )

    # if quantity is greater than product stock, don't save order_item
    if order_item.quantity > product.stock
      flash[:error] = "A problem occurred: #{product.title} does not have enough quantity in stock"
      redirect_to product_path(product.id)
      return
    else 
      order_item.save
      flash[:success] = "Successfully added #{product.title} to cart!"
      redirect_to product_path(product.id)
      return
    end
  end

  def update
    quantity = params[:order_item][:quantity].to_i # TODO: Confirm whether order_item is the correct key name (if the form uses the order_item model, this should be right)
    product = @order_item.product

    # if quantity is greater than product stock, don't update order_item 
    if quantity > product.stock
      flash[:error] = "A problem occurred: #{product.title} does not have enough quantity in stock"
      redirect_to orders_path
      return
    else 
      @order_item.update(order_item_params)
      flash[:success] = "Successfully updated the quantity of #{product.title}"
      redirect_to orders_path
      return
    end
  end

  def destroy
    # find order_item by id
    # not_found if nil

    # destroy order_item
    # flash success message
    
    # redirect to cart
  end

  private

  def find_order_item(id)
    @order_item = OrderItem.find_by(id: id)
    head :not_found if !@order_item
    return
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end
end
