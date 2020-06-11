class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
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
    # TODO: Set session ID to authenticated merchant
    session[:user_id] = 1

    # checking if a merchant is signed in
    if session[:user_id]
      @product = Product.new(product_params)
      @product.merchant_id = session[:user_id]
      if @product.save
        redirect_to products_path
      else
        render :new, status: :bad_request
      end
    else
      #say you must be loged in as a merchant to create product

    end


  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def product_params
      return params.require(:product).permit(:name, :description, :photo, :stock, :price, category_ids: [])
    end
end
