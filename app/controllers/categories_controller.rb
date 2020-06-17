class CategoriesController < ApplicationController
  before_action :find_category, except: [:index, :new]
  skip_before_action :require_login, only: [:index, :show]
  def index
    @categories = Category.all
  end

  def show
    if @category.nil?
      redirect_to categories_path
      return
    end
    # TODO: the pagination doesn't work
    @category_products = Category.includes(:products).paginate(page: params[:page], per_page: 6)
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
        flash[:result_text] = "Could not create a category #{@category.name}"
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
        return
      end
    end   
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end
  
end
