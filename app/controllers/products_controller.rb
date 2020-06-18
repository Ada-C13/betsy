class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :deactivate]
  before_action :require_login, only: [:new, :edit, :update, :deactivate]
  before_action :require_ownership, only: [:edit, :update, :deactivate]

  # GET /products
  # GET /products.json
  def index
    @filters = []
    @products = []

    if params[:categories]
      params[:categories].each do |c|
        if Category.exists?(c)
          category = Category.find(c)
          @products << category.products.where(active: true)
          @filters << category.name
        end
      end
    end

    if params[:merchants]
      params[:merchants].each do |m|
        if Merchant.exists?(m)
          @products << Product.where(merchant: m, active: true)
          @filters << Merchant.find(m).username
        end
      end
    end

    if @products.empty?
      @products = Product.all.where(active: true)
    else
      @products.flatten!.uniq!
    end
    
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = session[:merchant_id]
    @product.photo = 'https://i.imgur.com/OR9WgUb.png' if @product.photo = ''
    @product.active = true
    if @product.save
      flash[:success] = "Successfully created #{@product.name}"
      redirect_to product_path(@product)
    else
      flash.now[:warning] = "Unable to save product."
      flash.now[:details] = @product.errors.full_messages
      render :new, status: :bad_request
      return
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if @product.update(product_params)
      redirect_to @product
      flash[:success] = "Successfully updated product."
      return
    else 
      flash.now[:warning] = "Product update failed"
      flash.now[:details] = @product.errors.full_messages
      render :edit, status: :bad_request
      return
    end
  end

  def deactivate
    @product.active = !@product.active
    if @product.save
      redirect_to manage_products_path(@current_merchant)
    else
      flash[:warning] = "Unable to #{!@product.active} product"
    end
  end

  private

    def set_product
      @product = Product.find_by(id: params[:id])
      if @product.nil?
        head :not_found
        return 
      end
    end

    def product_params
      return params.require(:product).permit(:name, :description, :photo, :stock, :price, category_ids: [])
    end
end
