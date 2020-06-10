class ProductsController < ApplicationController

  before_action :require_login, only: [:new, :create, :destroy, :edit]

  def index
  end

  def new

  end 

  def create

  end 
end
