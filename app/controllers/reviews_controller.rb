class ReviewsController < ApplicationController

  before_action :find_product

  def create
    if @product
      if @product.merchant_id == session[:user_id]
        flash[:error] = "A problem occurred: A Merchant can not review their own product"
      else
        @review = Review.new(new_review_params)
        @review.product_id = @product.id

        if @review.save
          flash[:success] = "Successful!"
        else
          flash[:error] = "A problem occurred: Could not review"
        end
      end
      redirect_to request.referrer || product_path(@product.id)
    end

  end

  private

  def new_review_params 
    params.require(:review).permit(:rating, :description)
  end

  def find_product
    @product = Product.find_by(id: params.require(:product_id))
  end
end
