class ProductsController < ApplicationController

  before_action :require_login, only: [:new, :create, :destroy, :update, :edit, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def category_products
    @category = Category.find_by_id(params[:category_id])
    @category_products = @category.products #.sort{ |a, b| b.average_rating <=> a.average_rating }
  end

  def show
    if @product.nil?
      head :not_found
      return
    end
    @reviews = @product.reviews
  end

  def new
    @product = Product.new
  end 

  def create
    @product = Product.new(new_product_params)
  
    if @product.img_url == ""
      @product.img_url = "https://live.staticflickr.com/65535/50015899763_886c9985f5_m.jpg"
    end
    
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:status] = "Product Created!"
      
      redirect_to merchant_dashboard_path
    else
      flash[:error] = "Product did not save"
      render :edit, status: :bad_request
      return
    end 
  end 

  def edit 
    if @product.nil?
      head :not_found
      return
    elsif @product.merchant_id != session[:user_id]
      flash[:error] = "A problem occurred: A Merchant can not another merchant's product"
      redirect_to root_path
    end
  end 

  def update
    if @product.nil?
      head :not_found
      return
    else 
      if @product.update(new_product_params)
        flash[:success] = "Product updated successfully"
        redirect_to product_path(@product.id) 
        return
      else # save failed :(
        flash.now[:error] = "Something happened. Product not updated."
        render :edit, status: :bad_request # show the form view again
        return
      end
    end

  end 

  def destroy 
    if  @product.nil?
      head :not_found
      return
    end

    @product.destroy

    redirect_to merchant_dashboard_path
    return
  end 

  private 

  def new_product_params 
    return params.require(:product).permit(:name, :price, :img_url, :description, :qty, category_ids: [])
  end 

  def find_product
    @product = Product.find_by(id: params[:id])
  end
  
end
