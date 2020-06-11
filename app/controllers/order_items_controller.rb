class OrderItemsController < ApplicationController
  before_action only: [:update, :destroy] do
    find_order_item(params[:id])
  end

  def create
    # if session[:order_id] is nil 
      # create blank order
      # set session[:order_id] order.id

    # find product by params[:product_id] (nested route) -> products/:product_id/add, params: quantity
      # not_found if there is no product with that id

    # create new order_item with product_id, order_id, quantity from params, and shipped default to false 
      # if quantity is greater than product stock, flash error message, return to product show page
      # else flash success message
    
      # redirect to cart
  end

  def update
    # find order_item by id
    # not_found if nil

    # if quantity is greater than product stock, flash error message, return to product show page
    # else flash success message
    
    # redirect to cart
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
end
