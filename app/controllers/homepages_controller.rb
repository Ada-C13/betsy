class HomepagesController < ApplicationController
  def index
    @products = Product.all
  end

  def meet_the_team
  end
  
end
