class ProductsController < ApplicationController

  skip_before_action :current_merchant, except: [:new, :create, :edit, :update, :retire], raise: false

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
  
    @product.merchant_id = session[:merchant_id] 
    @product.active = true

    if @product.save 
      flash[:success] = "Successfully created #{@product.title}"
      redirect_to product_path(@product.id)

      return
    else
      render :new 
      return
    end
  end

  def edit 
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def update 
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "Successfully updated #{@product.title}"
      redirect_to product_path(@product.id)
      return
    else
      render :edit 
      return
    end
  end

  def add_to_cart
    # find product by the id passed in thru params
    product = Product.find_by(id: params[:id])
    return head :not_found if !product

    # creates a new order if there is no order_id saved to session
    if !session[:order_id]
      order = Order.create
      session[:order_id] = order.id
    end

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

  def index
    if params[:merchant_id]
      # This is the nested route, /merchants/:merchant_id/products
      merchant = Merchant.find_by(id: params[:merchant_id])
      @products = merchant.products
    else
      # This is the 'regular' route, /products
      @products = Product.all
    end
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def retire 
    @current_merchant = current_merchant
    @product = Product.find_by(id: params[:id])
    # binding.pry
    if @product.active
      @product.update(active: false)
      redirect_to product_path(@product.id)
    else
      @product.update(active: true)
      redirect_to product_path(@product.id)
    end
  end


  private 

  def product_params 
    return params.require(:product).permit(:title, :price, :description,
                                           :photo_url, :stock)
  end
end
