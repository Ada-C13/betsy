class CategoriesController < ApplicationController
  def new
  end

  def create
    @category = Category.new(params[:id])
    if @category.save
      flash[:success] = "Successfuly created #{@category.name} category"
      redirect_to dashboard_merchant(params[:id])
    else
      flash.now[:warning] = "Unable to save category."
      flash.now[:details] = @product.errors.full_messages
      render :new, status: :bad_request
    end
  end

  private

  def category_params
      return params.require(:category).permit(:name, :description)
  end
end
