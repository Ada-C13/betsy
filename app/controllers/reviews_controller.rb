class ReviewsController < ApplicationController
  def new
    @product_id = params[:product_id]
    if Product.find_by(id: @product_id.to_i).merchant_id == session[:merchant_id]
      flash[:error] = "You cannot review a product that you sell"
      redirect_back(fallback_location: root_path)
      return
    end

    @review = Review.new
  end

  def create
    @review = Review.create(review_params)

    if @review.save
      flash[:success] = "Review successfully added."
      redirect_to product_path(@review.product_id)
    else
      render :new, status: :bad_request
    end
  end

  private

  def review_params
    return params.require(:review).permit(:content, :rating, :product_id)
  end
end
