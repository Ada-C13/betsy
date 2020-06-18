class CategoriesController < ApplicationController
  before_action :find_category, except: [:index, :new]
  skip_before_action :require_login, only: [:index, :show, :category_products]
  def index
    @categories = Category.all
    redirect_to root_path
  end
  
  def category_products
    if @category.nil?
      redirect_to categories_path
      return
    end
    @category_products = @category.products.paginate(page: params[:page], per_page: 9)
  end

  def new
    @category = Category.new
  end

  def create
    if find_user
      @category = Category.new(category_params)
      if @category.save
        # flash[:status] = :success
        flash[:result_text] = "Successfully created #{@category.name.titleize}"
        redirect_to account_path(find_user.id)
        return
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create a category"
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
