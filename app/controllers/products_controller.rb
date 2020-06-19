class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :find_product, only: [:show, :edit, :update]

  def index
    @products = Product.where(status: "true")
  end

  def new
    if session[:user_id]
      @product = Product.new
    else
      flash[:error] = "Please log in to create a new product!"
    end
  end

  def create
    @product = Product.new(product_params) # Instantiate a new work
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:success] = "Your product was added."
      redirect_to product_path(@product.id)
      return
    else # if save fails
      flash.now[:error] = "Oops. We couldn't add your product because #{@product.errors.full_messages}."
      render :new, status: :bad_request # show the new product form again
      return
    end
  end

  def show
    if @product.nil?
      head :not_found
      return
    end

    if @product.status == false && @product.merchant_id != session[:user_id]
      flash[:error] = "Oops. That plant isn't available. Let's find you another beautiful plant."
      redirect_to products_path
      return
    end 
  end

  def edit
    if @product.nil?
      head :not_found
      return
    end
    
    if @product.merchant_id != session[:user_id]
      flash[:error] = "Oops. You can only edit your own products."
      redirect_to product_path(@product.id)
      return
    end
  end

  def update
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "Product updated!"
      redirect_to product_path(@product.id) 
      return
    else # save failed
      flash.now[:error] = "Oops! We couldn't update your product."
      render :edit, status: :bad_request # show the new product form view again
      return
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(
      :name, 
      :price, 
      :description, 
      :inventory, 
      :status, 
      :photo_url,
      category_ids: []
    )
  end
end
