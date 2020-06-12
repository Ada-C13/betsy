class ReviewsController < ApplicationController
#   # before_action :find_review, only: [:show]
#   # around_action :render_404, only: [:show], if: -> { @review.nil? }

#   # def index 
#   #   @reviews = Review.all
#   # end

#   # def show 
#   # end


  def new
    @review = Review.new
    @product = find_product
  end

  def create
    product = Product.find_by(id: find_product.id)

    if @login_user.id && (@login_user.id == product.user_id)
      flash[:error] = "A problem occurred: Cannot add a review for your own product!"
      redirect_to product_path(product.id)
      return
    else

    @review = Review.new(review_params) 

    if @review.save
      flash[:success] = "The review was successfully added! 😄"
    else
      flash[:error] = "A problem occurred: Could not update the review"
    end

    redirect_back(fallback_location: root_path)
    return
  end
end

  private

  def review_params
    params.permit(:rating, :description, :product_id)
  end

  def find_product
    return Product.find_by(id: params[:product_id])
  end
end