class ApplicationController < ActionController::Base
  before_action :require_login
  
  def current_user
    return Merchant.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def require_login
    if current_user.nil?
      flash[:error] = "Oops. Looks like you don't have permission to view this page. If you're a merchant, please login."
      redirect_to root_path
    end
  end

end
