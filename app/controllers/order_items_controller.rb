class OrderItemsController < ApplicationController
  skip_before_action :require_login, only: [:create, :destroy, :update ]
  def create
    @product = Product.find_by(id: params[:product_id])

    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    if @product.inventory < 1 || @product.inventory < params[:quantity].to_i
      flash[:error] = "Could not add item to order! We have no stock available"
      redirect_to product_path(@product.id)
      return
    end

    # Call private method to create a new session if the session is nil. 
    current_order = manage_session

    current_item = current_order.order_items.find_by(product_id: params[:product_id])
    # checks if item is already in order, updates by 1 if so
    if current_item
      # params[:quantity].to_i to add up the quantity
      if (current_item[:quantity] + params[:quantity].to_i) > @product.inventory
        flash[:error] = "You cannot add more items than are in stock."
        redirect_to product_path(@product.id)
      else
        current_item[:quantity] += params[:quantity].to_i
        current_item.save
        flash[:success] = "Successfully updated order item"
        redirect_to order_path(@order_id)
      end
      return
    end
    # Call method to create a new item if there is not current item in the order.
    create_new_orderItem
  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id].to_i)

    if order_item.nil?
      head :not_found
      return
    end

    order = Order.find_by(id: order_item.order_id)

    if order_item
      order_item.destroy
      flash[:success] = "#{order_item.product.name} successfully removed from your basket!"
    end

    return redirect_to order_path(order.id)
  end

  def update

    order_item = OrderItem.find_by(id: params[:id].to_i)

    if order_item.nil?
      head :not_found
      return
    end

    product = Product.find_by(id: order_item.product_id)
    order = Order.find_by(id: order_item.order_id)


    if order_item_params[:quantity].to_i > product.inventory
      flash[:error] = "You cannot add more items than are in stock"
      redirect_to order_path(order.id)
    elsif order_item.update(order_item_params)
      redirect_to order_path(order.id)
      return
    else # save failed :(
      flash[:error] = "Your order items was not updated "
      redirect_to order_path(order.id)
      return
    end
  end

  private

  # Manage session to create a new session order id if the session order_id is nil
  def manage_session
    # check order status to reassign new order
    order = Order.find_by(id: session[:order_id])
    if order.nil? || order.status == "paid"
      @order = Order.create(status:"pending")
      order = @order
    end
    @order_id = order.id
    session[:order_id] = @order_id
    return order 
  end

  # Method to create a new order Item.
  def create_new_orderItem
    order_item = OrderItem.new({
      product_id: params[:product_id],
      quantity: params[:quantity].to_i,
      order_id: session[:order_id],
    })

    if order_item.save
      flash[:success] = "Item added to order"
      redirect_to order_path(@order_id)
    else
      flash[:error] = "Could not add item to order"
      redirect_to order_path(@order_id)
    end
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity, :order_id, :product_id)
  end
end
