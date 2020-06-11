class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :add_to_cart, :remove_from_cart]
  
  def index
    @products = Product.where('stock > ?', 0)
    @products_by_merchant = Product.by_merchant(params[:merchant_id])

    session[:return_to] = products_path
  end

  def show    
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params) 

    if @product.save 
      redirect_to product_path(@product.id)
      flash[:success] = "Successfully added new product: #{view_context.link_to "##{@product.id} #{@product.name}", product_path(@product.id) }"
      return
    else 
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @product.nil?
      head :not_found
      return
    end
  end

  def update
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "Successfully edited #{view_context.link_to @product.name, product_path(@product.id)}" 
      redirect_to product_path(@product.id)
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def add_to_cart
    if @product.nil? 
      head :not_found
      return
    end

    if session[:shopping_cart].nil?
      session[:shopping_cart] = Hash.new()
    end

    if @product.stock > 0
      if session[:shopping_cart][@product.id.to_s] 
        session[:shopping_cart][@product.id.to_s] += 1
      else
        session[:shopping_cart][@product.id.to_s] = 1
      end
      flash[:success] = "You have successfully added on to the cart!"
    else
      flash[:warning] = "Sorry, this product is currently out of stock!"
    end

    redirect_to session.delete(:return_to)
    return
  end

  def remove_from_cart
    if @product.nil? 
      head :not_found
      return
    end

    if session[:shopping_cart].nil?
      session[:shopping_cart] = Hash.new()
    end

    if session[:shopping_cart][@product.id.to_s] > 0
      session[:shopping_cart][@product.id.to_s] -= 1
      flash[:success] = "You have successfully removed on to the cart!"
    else
      flash[:warning] = "Item has been fully removed from cart."
    end

    redirect_to session.delete(:return_to)
    return
  end

  private

  def product_params
    complete_params = params.require(:product).permit(:name, :description, :price, :stock, :photo_url)
    complete_params[:merchant_id] = session[:merchant_id]
    return complete_params
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

end
