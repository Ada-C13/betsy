class OrderItemsController < ApplicationController
  before_action only: [:update, :destroy, :ship] do
    find_order_item
  end

  def update
    quantity = order_item_params[:quantity].to_i
    product = @order_item.product

    # if quantity is greater than product stock, don't update order_item 
    if quantity > product.stock
      flash[:status] = :failure
      flash[:result_text] = "#{product.title} does not have enough quantity in stock"
      redirect_to cart_path
      return
    else 
      @order_item.update(order_item_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated the quantity of #{product.title}"
      redirect_to cart_path
      return
    end
  end

  def destroy
    @order_item.destroy
    flash[:status] = :success
    flash[:result_text] = "Successfully removed #{@order_item.product.title} from cart!"
    redirect_to cart_path
    return
  end

  def ship
    if !@order_item.shipped
      @order_item.update(shipped: true)
      if @order_item.order.order_items.all? { |item| item.shipped == true }
        @order_item.order.update(status: "complete")
      end
      flash[:status] = :success
      flash[:result_text] = "Successfully shipped #{@order_item.product.title}!"
      redirect_to merchant_path(@order_item.product.merchant.id)
      return
    end
  end

  private

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    head :not_found if !@order_item
    return
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity)
  end
end
