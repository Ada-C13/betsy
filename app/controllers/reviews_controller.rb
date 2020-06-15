class ReviewsController < ApplicationController
  skip_before_action :require_login, except: [:account]
  before_action :find_review, only: [:show, :create, :index] # making my codes DRY
  
  def index
    @reviews = Review.all
  end
  
  def new
    @review = Review.new
  end

  def create
    @product = Product.find_by(id: params[:id])
    @review = Review.new(review_params)
    
    if @product.nil?
      head :not_found
      return
    end
    
    if session[:merchant_id] == @product.merchant_id
        flash.now[:warning] = "A problem occurred: Could not add a review"
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
