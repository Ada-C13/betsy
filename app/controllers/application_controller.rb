class ApplicationController < ActionController::Base

  # before_action :require_login
  before_action :find_user

  def current_merchant
    return @current_merchant = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:status] = :failure 
      flash[:result_text] = "You must be logged in to do that"

      redirect_to root_path
    end
  end

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  private

  def find_user
    if session[:merchant_id]
      @login_user = Merchant.find_by(id: session[:merchant_id])
    end
  end

end
