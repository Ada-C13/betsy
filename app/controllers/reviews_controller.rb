class ReviewsController < ApplicationController
  FIELDS = [:rating, :description, :product_id, :reviewer]

  def new
    @review = Review.new
    @product = find_product
  end

  def create
    @product = find_product

    
    if @login_user && (@login_user.id == @product.user_id)
      flash[:error] = "A problem occurred: Cannot add a review for your own product!"
      redirect_back(fallback_location: root_path)
      return

    else

      if @login_user 
        @review = Review.new(review_params) 
        @review.reviewer = @login_user.name
      else 
        @review = Review.new(review_params) 
      end
    
      if @review.save
        flash[:success] = "The review was successfully added! 😄"
      else
        messages = []

        FIELDS.each do |field|
          if @review.errors.messages.include?(field)
            messages << "'#{field.capitalize}' - #{@review.errors.messages[field].join(", ")}"
          end
        end

        flash[:error] = "A problem occurred: Could not update the review \n\n#{messages.join(", ")}"
      end 

      redirect_back(fallback_location: root_path)
      return
    end
  end

  private

  def review_params
    return params.permit(*FIELDS)
  end

  def find_product
    return Product.find_by(id: params[:product_id])
  end
end