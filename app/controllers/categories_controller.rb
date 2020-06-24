class CategoriesController < ApplicationController
  helper_method :render_404, :require_login 

  around_action :require_login, only: [:new, :update], if: -> { !@login_user }
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  around_action :render_404, only: [:show, :edit, :update, :destroy], if: -> { @category.nil? }

  def index 
    @categories = Category.all.order(:name)
  end

  def show 
  end

  def new 
    @category = Category.new
  end

  def create 
    @category = Category.new(category_params)

    if @category.save 
      flash[:success] = "#{@category.name} was successfully added! 😄"
      redirect_to categories_path
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update '#{@category.name}'"
      render :new 
      return
    end
  end

  def update 
    if @category.update(category_params)
      flash[:success] = "#{@category.name} was successfully edited! 😄"
      redirect_to category_path(@category.id)
      return
    else 
      flash.now[:error] = "The category was not successfully edited :("
      render :edit 
      return
    end
  end

  private 

  def category_params 
    return params.require(:category).permit(:name)
  end

  def find_category
    category_id = params[:id]
    @category = Category.find_by(id: category_id) 
  end
end
