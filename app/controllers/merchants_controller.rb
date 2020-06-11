class MerchantsController < ApplicationController

  def show 
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      redirect_to products_path
    end
  end
end
