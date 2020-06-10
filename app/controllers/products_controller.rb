class ProductsController < ApplicationController

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    @product.merchant_id = Merchant.find_by(id: 1).id # temporary code before log in is implemented

    if @product.save 
      flash[:success] = "Successfully created #{@product.title}"
      redirect_to product_path(@product.id)

      return
    else
      render :new 
      return
    end
  end


  private 

  def product_params 
    return params.require(:product).permit(:title, :price, :description,
                                           :photo_url, :stock)
  end

end
