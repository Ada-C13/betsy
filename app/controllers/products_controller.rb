class ProductsController < ApplicationController
  def index
    if params[:merchant_id]
      # This is the nested route, /merchants/:merchant_id/products
      merchant = Merchant.find_by(id: params[:merchant_id])
      @products = merchant.products
    else
      # This is the 'regular' route, /products
      @products = Product.all
    end
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      redirect_to products_path
      return
    end
  end

end
