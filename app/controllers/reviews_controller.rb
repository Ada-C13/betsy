class ReviewsController < ApplicationController
  def new 
    @review = Review.new
  end

  def create 
    @review = Review.new(review_params)
    @review.product_id = session[:product]["id"]
    if @review.save 
      flash[:status] = :success
      flash[:result_text] = "Successfully created a new review for #{@review.product.title.capitalize}"
      redirect_to product_path(@review.product.id)
      return
    else
      flash[:status] = :failure
      flash.now[:result_text] = "Could not create review!"
      flash.now[:messages] = @review.errors.messages
      render :new, status: :bad_request
      return
    end
  end

  private 

  def review_params 
    return params.require(:review).permit(:text, :rating, :product_id)
  end
end
