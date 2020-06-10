class OrdersController < ApplicationController
  before_action only: [:show, :edit, :update, :destroy] do
    find_order(params[:id])
  end
  
  def show
  end
  
  def create
    # when a customer adds a product to their cart
    # no products in cart: a new order is created, order_id stored in session?, an order_item is created and put into the cart
    # products in cart: an order_item is created and put into the cart
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def find_order(id)
    @order = Order.find_by(id: id)
    head :not_found if !@order
    return @order
  end
end
