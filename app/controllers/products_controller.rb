class ProductsController < ApplicationController

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)

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
