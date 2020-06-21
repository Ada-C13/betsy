class CategoriesController < ApplicationController
  before_action :require_login, only: [:new]

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)
    if @category.id?
      flash[:success] = "Successfully added the #{@category.category_name} category"
      redirect_to merchant_path(session[:merchant_id])
    else
      flash[:result_text] = "Could not create category"
    end
  end


  def category_params
    params.require(:category).permit(:category_name)
end
end
