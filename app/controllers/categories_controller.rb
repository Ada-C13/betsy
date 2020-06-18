class CategoriesController < ApplicationController
  def new 
   # let me see a new category page if I'm a merchant. Else show not_found page
    if current_merchant
      @category = Category.new
    else
      head :not_found
    end
  end

  def create 
    @category = Category.new(category_params)

    if @category.save 
      flash[:status] = :success
      flash[:result_text] = "Successfully created a new category: #{@category.title}"
      redirect_to new_product_path
      return
    else
      flash[:status] = :failure
      flash.now[:result_text] = "Could not create category!"
      flash.now[:messages] = @category.errors.messages
      render :new, status: :not_found
      return
    end
  end

  private 

  def category_params 
    return params.require(:category).permit(:title)
  end
end
