

class UsersController < ApplicationController

  def index
    # @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    
    if @user.nil?
      head :not_found
      return
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      flash[:success] = "Logged in as returning user #{user.name}"
    else
      # create new user
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        # if there's a bug
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    # valid user
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end

  def myaccount
    if @logged_user
      @products = Product.where(user_id: @logged_user.id)
    else
      flash[:error] = "You must be logged in to see this page"
      return redirect_to root_path
    end
  end
  
  def myorders
    if @logged_user
      @order_items = @logged_user.order_items
      if params[:filter]
        @order_items = @order_items.select{ |order_item| order_item.order_item_status == params[:filter] }
      end
    else
      flash[:error] = "You must be logged in to see this page"
      return redirect_to root_path
    end
  end

end
