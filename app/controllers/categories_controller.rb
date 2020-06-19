class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfuly created #{@category.name} category"
      redirect_to dashboard_merchant_path(@current_merchant)
    else
      flash.now[:warning] = "Unable to save category."
      flash.now[:details] = @category.errors.full_messages
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name, :description)
  end
end
