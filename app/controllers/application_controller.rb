class ApplicationController < ActionController::Base
  before_action :set_users, :current_user 

  private
  def set_users
    @users = User.all
  end

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end

  def current_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_back(fallback_location: frontpage_path)
    end
  end
end
