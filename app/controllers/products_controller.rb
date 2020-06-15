class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :create, :destroy] # making my codes DRY
  skip_before_action :require_login, only: [:index, :show]

  
  def index
    @products = Product.all
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
    
    if session[:merchant_id]
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id]

      if @product.save
        flash[:success] = "Successfully created #{@product.name}"
        redirect_to products_path
        return
      else
        flash.now[:warning] = "A problem occurred: Could not create product"
        render :new, status: :bad_request
        return
      end
    else
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to products_path
      return
    end
  end

  def edit
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def update
    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = " Successfully updated #{@product.name}"
      redirect_to product_path(@product)
      return
    else 
      flash.now[:error] = @edited_product_hash
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @product.nil?
      head :not_found
      return
    else
      @product.destroy
      flash[:success] = "Successfully deleted #{@product.name}"
      redirect_to products_path
      return
    end
  end 

  def toggle_active
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    end
    
    if @product[:active]
      @product.update(active: false)
      # redirect_to merchant_path(session[:merchant_id])
    else 
      @product.update(active: true)
      # redirect_to merchant_path(session[:merchant_id])
    end
    redirect_to merchant_path(session[:merchant_id])
    return
  end
  
  private

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :active, :description, :photo, :merchant_id)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

end
