class ApplicationController < ActionController::Base
  before_action :current_merchant

  def current_merchant
    if session[:user_id]
      @current_merchant = Merchant.find_by(id: session[:user_id])
    end
  end

  def require_login
    if current_merchant.nil?
      flash[:message] = "You must be logged in to do this"
      redirect_to root_path
    end
  end
end
