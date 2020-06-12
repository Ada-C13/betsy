class ProductsController < ApplicationController

  # this is just for temporary use to serve as the root_path
  # please replace it with Lak's products controller when merging
  def index
    @products = Product.all
  end
end
