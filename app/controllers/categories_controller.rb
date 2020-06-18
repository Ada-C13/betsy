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
      if @category.name
        @category.name = @category.name.downcase.titleize
      end
    
      if @category.save
        flash[:result_text] = "Successfully created #{@category.name}"
        redirect_to account_path(find_user.id)
        return
      else
        flash.now[:error] = "A problem occurred: Could not create category"
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
