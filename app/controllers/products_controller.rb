class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :update, :edit, :retired]
  before_action :require_login, only: [:new, :edit]

  def index
    if params[:category_name]
      @products = Category.find_by(category_name: params[:category_name]).products
      @collection_name = params[:category_name]
    elsif params[:username]
      @products = Merchant.find_by(username: params[:username]).products
      @collection_name = "Products by #{params[:username]}"
    else
      @products = Product.all
      @collection_name = "all products"
    end
  end

  def show ; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    if @product.id?
      flash[:success] = "#{@product.product_name} successfully added."
      redirect_to product_path(@product.id)
    else
      render :new
    end

    rescue ActionController::ParameterMissing
    redirect_to new_product_path
  end

  def update
    if @product.update(product_params)
      flash[:success] = "#{@product.product_name} successfully updated"
      redirect_to product_path(@product)
      return
    else
      render :edit
      return
    end
  end

  def edit
    if @product.merchant != @current_user
      flash[:error] = "You cannot edit a product that you do not sell"
      redirect_back(fallback_location: root_path)
      return
    end

    if @product.nil?
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def retired
    if @product.merchant != @current_user
      flash[:error] = "You cannot retire a product that you do not sell"
      redirect_back(fallback_location: root_path)
      return
    end

    if @product.retire!
      flash[:success] = "#{@product.product_name} successfully retired!"
      redirect_back(fallback_location: root_path)
      # redirect_to merchant_path(session[:merchant_id]) #or wherever you want to redirect to
    end
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    end
  end

  def product_params
    return params.require(:product).permit(:product_name, :price, :description, :photo_url, :stock, :merchant_id, category_ids: [])
  end
end