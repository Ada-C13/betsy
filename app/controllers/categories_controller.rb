class CategoriesController < ApplicationController
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
      redirect_to category_path(@category)
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@category.name}"
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


  def destroy
    if @category.destroy
      flash[:success] = "Successfully destroyed category #{@category.id}"
      redirect_to categories_path 
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

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end
end
