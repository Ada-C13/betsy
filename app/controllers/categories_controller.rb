class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@category.id}"
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create a category"
      flash[:messages] = @work.errors.messages
      render :new, status: :bad_request
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
