class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def add_to_cart
    # creates a new order if there is no order_id saved to session
    if !session[:order_id]
      order = Order.create(status: "pending")
      session[:order_id] = order.id
    end

    # find product by the id passed in thru params
    product = Product.find_by(id: params[:id])
    return head :not_found if !product

    # create new order_item
    order_item = OrderItem.new(
      product_id: product.id,
      order_id: session[:order_id],
      quantity: params[:quantity],
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
end
