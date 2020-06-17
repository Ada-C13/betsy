class ReviewsController < ApplicationController

  def new
    if params[:product_id]
      # Nested route: /product/:product_id/reviews/new
      product = Product.find_by(id: params[:product_id])
      @review = Review.new
    else 
      redirect_to root_path
      flash[:danger] = "Something went wrong with the reviewing process."
    end
  end


  def create
    
    # if there is a merchant logged in
    # if session[:merchant_id]?
      
    # # and that merchant ID matchs the product id
    #   if @product_id == session[:merchant_id]
    # # merchant can't review their own product
    #   end
    # end
  @review = Review.new(review_params)
  @review.product_id = params[:product_id]

    if @review.save
      flash[:success] = "Thank you! Your review has been successfully added"
      redirect_to product_path(params[:product_id])
      return
    else
      flash.now[:danger] = request.params
      flash[:details] = @review.errors.full_messages
      render :new, status: :bad_request
      return
    end
  end

  
  private
 
  def review_params
    return params.require(:review).permit(:rating, :comment, :product_id)
  end

end
