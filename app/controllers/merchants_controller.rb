class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end
  
  def create
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: auth_hash[:uid],
      provider: params[:provider])
      if merchant
        flash[:notice] = "Logged in as returning merchant #{merchant.username}"
      else
        merchant = Merchant.build_from_github(auth_hash)
        if merchant.save
          flash[:success] = "Logged in as new merchant #{merchant.username}"
        else
          flash[:error] = "Unable to create new merchant: #{merchant.errors.messages}"
          return redirect_to root_path
        end
      end
      session[:merchant_id] = merchant.id
      redirect_to root_path
    end
    
    def show
      @merchant = Merchant.find_by(id: params[:id])
      render_404 unless @merchant
    end
    
    def logout
      session[:merchant_id] = nil
      flash[:status] = :success
      flash[:result_text] = 'Successfully logged out'
      redirect_to root_path
    end
  end