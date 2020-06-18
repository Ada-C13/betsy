class ReviewsController < ApplicationController
  before_action :merchant_reviews, only:[:new, :create]

  def new
    @review = Review.new
  end


  def create

  @review = Review.new(review_params)
  @review.product = @product

    if @review.save
      flash[:success] = "Thank you! Your review has been successfully added"
      redirect_to product_path(@product)
      return
    else
      flash.now[:danger] = request.params
      flash[:details] = @review.errors.full_messages
      render :new, status: :bad_request
      return
    end
  end

  
  private

  def merchant_reviews

    @product = Product.find_by(id: merchant_review_params)
    unless @product
      flash[:warning] = "Product not found!"
      redirect_to products_path
      return
    end
    
    if @product&.merchant == @current_merchant
      flash[:warning] = "You can't review your own product!"
      redirect_to product_path(@product)
    end
  end

  def merchant_review_params
    params.require(:product_id)
  end
 
  def review_params
    params.require(:review).permit(:rating, :comment, :product_id)
  end

end
