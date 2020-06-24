class UsersController < ApplicationController
  helper_method :render_404

  before_action :require_login, only: [:destroy, :dashboard]

  def index
    @users = User.all.order(:name).paginate(:page=>params[:page],:per_page=>15)
  end

  def show
    @user = User.find_by(id: params['id'])

    if @user.nil?
      return render_404 
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: 'github')

    if user
      flash[:success] = "Logged in as returning user #{user.name}"
    else

      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
      end
    end

    session[:user_id] = user.id
    redirect_back(fallback_location: frontpage_path)
    return
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_back(fallback_location: frontpage_path)
    return
  end

  def dashboard
    @user = User.find_by(id: session[:user_id])

    @revenue = 0
    @paid_revenue = 0
    @paid_count = 0
    @shipped_revenue = 0
    @shipped_count = 0

    Order.all.each do |order|
      order.order_items.each do |item|
        merchant_product = Product.find_by(id: item.product_id)

        if @user.id == merchant_product.user_id
          @revenue += (item['quantity'] * merchant_product.price)

          if order.status == 'shipped'
            @shipped_revenue += item['quantity'] * merchant_product.price
            @shipped_count += 1
          elsif order.status == 'paid'
            @paid_revenue += item['quantity'] * merchant_product.price
            @paid_count += 1
          end
        end
      end
    end
  end
end