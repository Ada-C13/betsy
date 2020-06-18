class ProductsController < ApplicationController
  before_action :find_product, except: [:index, :new]
  skip_before_action :require_login, only: [:index, :show]

  
  def index
    @products = Product.paginate(page: params[:page], per_page: 9)
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
    # byebug  
    if session[:merchant_id]
      merchant = Merchant.find_by(id: session[:merchant_id])
      @product = Product.new(product_params)
      @product.merchant = merchant

      if @product.save
        flash[:success] = "Successfully created #{@product.name}"
        redirect_to account_path(merchant)
        return
      else
        flash.now[:error] = "A problem occurred: Could not create product"
        render :new, status: :bad_request
        return
      end
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
      flash[:success] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product)
      return
    else 
      flash.now[:error] = "#{@product.errors.messages}"
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    end
    if session[:merchant_id]
      merchant = Merchant.find_by(id: session[:merchant_id])
      # We can delete any product that is NOT in the cart and it has already been shipped
      all_shipped_order_items = @product.order_items.select {|order_item| order_item.status != "shipped"}
      all_products_ids = all_shipped_order_items.map {|order_item| order_item.product_id}
    
      if session[:merchant_id] == @product.merchant_id && !all_products_ids.include?(@product.id)
        @product.destroy
        flash[:success] = "Successfully deleted the product"
        redirect_to account_path(merchant)
        return
      else 
        flash[:warning] = "Sorry, You cannot delete for this product."
        redirect_to account_path(merchant) 
        return
      end
    end
  end 

  def toggle_active
    if @product.nil?
      head :not_found
      return
    end
    @product.change_active
    flash[:success] = "#{@product.name} active status changed."
    redirect_to account_path(session[:merchant_id])
    return
  end
  
  private

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :active, :description, :photo, :merchant_id, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

end
