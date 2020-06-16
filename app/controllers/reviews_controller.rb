class ReviewsController < ApplicationController
  skip_before_action :require_login, except: [:account]
  before_action :find_review, only: [:show, :create, :index] # making my codes DRY
  
  def index
    @reviews = Review.all
  end
  
  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
    @review.product = @product
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)
    @review.product = @product
    if @product.nil?
      head :not_found
      return
    end
    
    if session[:merchant_id] == @product.merchant_id
        flash[:warning] = "Sorry, You cannot a review for your own product."
        redirect_to product_path(@product.id)
        return
    else
      if @review.save
        flash[:success] = " Successfully added a review"
        redirect_to product_path(@product.id)
        return
      else
        flash.now[:warning] = "A problem occurred: Could not add a review"
        render :new, status: :bad_request
        return
      end
    end
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :feedback, :product_id)
  end

  def find_review
    @review = Review.find_by(id: params[:id])
  end
  
end
