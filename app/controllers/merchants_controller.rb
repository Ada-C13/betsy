class MerchantsController < ApplicationController
  
  before_action :require_login, except: [:index, :create, :logout]

  def index
    @merchants = Merchant.all
  end
  
  def create
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: auth_hash[:uid],
      provider: params[:provider])
      if merchant
        flash[:status] = :success
        flash[:result_text] = "Logged in as returning merchant #{merchant.username}"
      else
        merchant = Merchant.build_from_github(auth_hash)
        if merchant.save
          flash[:status] = :success
          flash[:result_text] = "Logged in as new merchant #{merchant.username}"
        else
          flash[:status] = :failure
          flash[:result_text] = "Unable to create new merchant: #{merchant.errors.messages}"
          return redirect_to root_path
        end
      end
      session[:merchant_id] = merchant.id
      redirect_to root_path
    end
    
    def logout
      session[:merchant_id] = nil
      flash[:status] = :success
      flash[:result_text] = 'Successfully logged out'
      redirect_to root_path
    end
  
  def show 
    # Does not allow showing other merchant's dashboard
    if session[:merchant_id].to_s != params[:id]
      head :not_found
      return
    end
    @merchant = Merchant.find_by(id: params[:id])
  end
end