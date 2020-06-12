class OrderItemsController < ApplicationController
  before_action only: [:update, :destroy] do
    find_order_item(params[:id])
  end

  def index
    # shows all order_items that match session[:order_id]
    @order_items = OrderItem.where(order_id: session[:order_id])
  end

  def update
    quantity = order_item_params[:quantity].to_i
    product = @order_item.product

    # if quantity is greater than product stock, don't update order_item 
    if quantity > product.stock
      flash[:error] = "A problem occurred: #{product.title} does not have enough quantity in stock"
      redirect_to cart_path
      return
    else 
      @order_item.update(order_item_params)
      flash[:success] = "Successfully updated the quantity of #{product.title}"
      redirect_to cart_path
      return
    end
  end

  def destroy
    @order_item.destroy
    flash[:success] = "Successfully removed #{@order_item.product.title} from cart!"
    redirect_to cart_path
    return
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
