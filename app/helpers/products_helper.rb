module ProductsHelper

  def product_owned_by_merchant?(product)
    product.merchant == @current_merchant
  end
end
