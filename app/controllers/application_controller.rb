class ApplicationController < ActionController::Base

  

  def current_merchant
    merchant = Merchant.find(session[:user_id])
    return merchant
  end

  def require_login
    if current_merchant().nil?
      flash[:error] = "You must be logged in to do this"
      redirect_to root_path
    end
  end
end
