class CategoriesController < ApplicationController

  def index  
    @categories = Category.category_options
  end 



end
