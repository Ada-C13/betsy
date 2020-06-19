class ReviewsController < ApplicationController
  before_action :get_product
  skip_before_action :require_login

  def new
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    validate_merchant
    @review = @product.reviews.new
  end
  
  def create
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    validate_merchant
    @review = @product.reviews.new(review_params)

    if @review.save
      flash[:success] = "Thank you for reviewing #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "A problem occurred: Could not create review"
      render :new
    end
  end
  
  private

  def get_product
    @product = Product.find_by(id: params[:product_id])
  end

  def validate_merchant
    product = get_product
    if product.merchant_id == session[:merchant_id]
      flash[:error] = "You cannot review your own products"
      redirect_to product_path(product.id)
    end
  end

  def review_params
    return params.require(:review).permit(:rating, :description)
  end 
end
