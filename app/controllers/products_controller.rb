class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @filters = []
    @products = []

    if params[:categories]
      params[:categories].each do |c|
        if Category.exists?(c)
          category = Category.find(c)
          @products << category.products
          @filters << category.name
        end
      end
    end

    if params[:merchants]
      params[:merchants].each do |m|
        if Merchant.exists?(m)
          @products << Product.where(merchant: m)
          @filters << Merchant.find(m).username
        end
      end
    end

    if (!params[:categories] && !params[:merchants]) || (params[:categories].one? && params[:merchants].one?)
      @products = Product.all
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
    # checking if a merchant is signed in
    if session[:merchant_id]
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id]
      @product.photo = 'https://i.imgur.com/OR9WgUb.png' if @product.photo = ''
      if @product.save
        flash[:success] = "Successfully created #{@product.name}"
        redirect_to products_path
      else
        flash.now[:warning] = 'Unable to save product'
        flash.now[:details] = @product.errors.full_messages
        render :new, status: :bad_request
        return
      end
    else
      #say you must be loged in as a merchant to create product
      flash.now[:warning] = 'Must be logged in as Merchant to create a product'
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
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

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      raise
      return params.require(:product).permit(:name, :description, :photo, :stock, :price, category_ids: [])
    end
end
