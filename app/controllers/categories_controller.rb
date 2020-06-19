class CategoriesController < ApplicationController

  before_action :require_login, only: [:create]
  before_action :find_category, only: [:create]

  def new
    @category = Category.new
  end 

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "category added successfully"
      redirect_to root_path
      return
    else
      flash.now[:error] = "Something happened. category not added."
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end

end
