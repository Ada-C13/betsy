class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :change_product_status]

  def index
    @products = Product.where(product_status: "active")
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(
      product_params
    )

    if !@logged_user
      flash[:error] = "You must be logged in to create a new product."
      redirect_to root_path
      return
    end
    @product.user_id = @logged_user.id
    if @product.valid? && @product.photo_url.empty?
      @product.photo_url = "https://lh3.googleusercontent.com/0hJSje8_Z034MV_zDnQFGVt1Id-P21tDb3AP-J7WFtH0ITgL47YvUV642kZg1fXxtZaO47A14pRjWP2tG-2AlHm7jst2i8mB-yZQPX0I67SB4X9iJs4Co9lge5RlgsMoK8BeP1pXNtKuQkneNuBrxPr-x6n2KpVj7tA_E4k1krdZPj6Z_kZT8XzNIN_ztY3rD9HdwInpgaQ7HYImlTdGo_A50RoLEJ-7sK2_gFJAbSLIwnxEAAcaw7ELKxhO0p2QUbBk8Qwp3GnleViM2LVIUIQMcQDt7JvcKgPWH1DpNYpv8GRitVPOIBOt4mVvsVSJ5I6iBXU_7Tz1b1HQC97OajROBAWNSYryi_wqrac6MjfwFS0VbRxiAthPtUxApWpwTmxSF8LTqtUh2MQfLnOGp4wnX-CkfIQzqazG20xxXvsv24iLE1PZwjwkFb2vE8fglhUr0PAvEHseJz7D1PJwt5MtH38gdDPTK8o8WhJ1R4vGaiCqcekvR6OUGy4DYUEjW-zd3psZpwuQLxPLlgefvSvL4lErgVrxV8bg61cn7WcQ2Avev4L36DAS40RyY0cqInt_CJ-9Ovp3oRPTwTp0EwEL2XmHHKoW8yaSgJloyjAzWT9SHAAnoAoTjHWeHvXot8qdWvT8dwmq-LRsR_-cpE5-qNo2ejrkDUrCD5k7R35r5F_TKXLG9CX-Tkrf7g=w600-h512-no?authuser=0"
    end

    if @product.save
      flash[:success] = "#{@product.name} successfully added!"
      redirect_to products_path
      return
    else
      flash.now[:error] = "Unable to add #{@product.name}. Errors: #{@product.errors.messages}"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if session[:user_id] == nil || session[:user_id] != @product.user_id
      flash[:error] = "You can't edit a product that isn't yours"
      redirect_to root_path
      return
    end
  end

  def update
    if @product.update(
      product_params
    )
  
      flash[:success] = "#{@product.name} successfully edited"
      redirect_to products_path
      return
    else
      flash.now[:error] = "Unable to edit #{@product.name}. Errors: #{@product.errors.messages}"
      render :edit
      return
    end
  end

  def change_product_status
    if @product.product_status == "active"
      @product.product_status = "inactive"
    elsif @product.product_status == "inactive"
      @product.product_status = "active"
    end

    @product.save
    redirect_to myaccount_path
    return
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to root_path
      return
    end
  end

  def product_params
    return params.require(:product).permit(:name, :price, :description, :photo_url, :stock, :user_id, :product_status, category_ids: [])
  end
end
