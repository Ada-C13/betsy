class CategoriesController < ApplicationController
  def new 
    @category = Category.new
  end

  def create 
    @category = Category.new(category_params)

    if @category.save 
      flash[:success] = "Successfully created #{@category.title}"
      redirect_back(fallback_location: root_path)
      return
    else
      render :new 
      return
    end
  end

  private 

  def category_params 
    return params.require(:category).permit(:title)
  end
end
