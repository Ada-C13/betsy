class ApplicationController < ActionController::Base

  def find_merchant
    if session[:merchant_id]
      return @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end
  
end