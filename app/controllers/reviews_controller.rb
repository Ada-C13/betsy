class ReviewsController < ApplicationController

  def new
    if params[:product_id]
      # Nested route: /product/:product_id/reviews/new
      product = Product.find_by(id: params[:product_id])
      @review = product.reviews.new
    else
      # Else, create a new one
      @review = Review.new
    end
  end


  def create
    # if there is a merchant logged in
    # and that merchant ID matchs the product id
    # merchant can't review their own product

    review = Review.new(review_params)

    if review.save
      flash[:success] = "Thank you! Your review has been successfully added"
      redirect_to product_path(review_params[:product_id])
      return
    else
      flash.now[:error] = "Your review hasn't been added."
      render :new, status: :bad_request
      return
    end
  end

  
  private
 
  def review_params
    return params.require(:review).permit(:rating, :comment)
  end

end
