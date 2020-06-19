class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_merchant
  before_action :require_login

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  private

  def find_merchant
    if session[:merchant_id]
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

  def current_merchant
    if session[:merchant_id]
      @current_merchant = Merchant.find(session[:merchant_id])
    else
      return nil
    end
  end

  def require_login
    if current_merchant.nil?
      flash[:result_text] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end
end
