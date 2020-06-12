class ProductsController < ApplicationController
  
  before_action :find_product, only: [:show, :edit, :update, :destroy] # making my codes DRY
  
  def index
    @products = Product.all
  end

  def show
    if @product.nil?
      redirect_to proucts_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    
    if session[:merchant_id]
      @product = Product.new(product_params)
        # name: params[:name], 
        # price: params[:price], 
        # stock: params[:stock], 
        # active: params[:active],
        # description: params[:description], 
        # photo: params[:photo], 
        # merchant_id: session[:merchant_id])
      @product.merchant_id = session[:merchant_id]
       

      if @product.save
        flash[:success] = " Successfully created #{@product.name}"
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
      flash.now[:error] = "A problem occurred: Could not update #{@product.name} "
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
  
  private

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :active, :description, :photo, :merchant_id)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

end
