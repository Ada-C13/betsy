class ProductsController < ApplicationController

  before_action :verify_merchant, only: [:edit, :update, :retire, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :retire, :destroy]

  skip_before_action :require_login, only: [:root, :show, :index]

  def index 
    @products = Product.all
  end 

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.active = true 
    @product.merchant_id = session[:merchant_id]
    if @product.save 
      flash[:success] = "#{@product.name} has been added to the product database"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something happened. #{@product.name} was not added to the product database"
      render :new, status: :bad_request
      return
    end
  end

  def edit 
  end 

  def update 
    if @product.update(product_params)
      flash[:success] = "Successfully updated product #{@product.name}"
      redirect_to product_path(@product.id)
      return 
    else  
      flash.now[:error] = "Could not update product #{@product.name}. Please see error message"
      render :edit
      return 
    end 
  end 

  def retire
    if @product.update(active: false)
      flash[:success] = "#{@product.name} has been retired."
    else  
      flash[:error] = "#{@product.name} could not be retired."
    end 

    redirect_to current_merchant_path
    return 
  end

  def destroy 
    @product.destroy
    flash[:success] = "#{@product.name} has been deleted from the product database."
    redirect_to current_merchant_path
    return 
  end 

  private

  def product_params
    return params.require(:product).permit(:name, :artist, :price, :inventory, :image, :merchant_id, :active, category_ids:[])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil? 
      flash[:error] = "Product could not be found."
      redirect_to products_path
      return 
    end
    return @product
  end

  def verify_merchant
    if find_product
      if @product.merchant_id != session[:merchant_id]
        flash[:error] = "You are not authorized to do this."
        redirect_back(fallback_location: root_path)
        return
      end
    end
  end

end
