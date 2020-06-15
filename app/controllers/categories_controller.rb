class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      redirect_to categories_path
      return
    end
  end

  def new
    @category = Category.new
  end

  def create
    if find_user
      @category = Category.new(category_params)
      if @category.save
        # flash[:status] = :success
        flash[:result_text] = "Successfully created #{@category.name}"
        redirect_to account_path(find_user.id)
        return
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create a category"
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
        return
      end
    else
      flash[:result_text] = "You must log in to create a category"
      redirect_to categories_path
      return
    end   
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
