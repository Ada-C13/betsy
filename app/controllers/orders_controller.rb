class OrdersController < ApplicationController
  before_action :require_login, only: [:ordered, :index]

  def index
    @merchant_orders = []
    @merchant_products = []

    Order.all.each do |order|
      order.order_items.each do |item|
        merchant_product = Product.find_by(id: item.product_id)

        if session[:user_id] == merchant_product.user_id
          if !@merchant_orders.include?(order)
            @merchant_orders << order
            @merchant_products << merchant_product
          end
        end
      end
    end
  end

  def new 
    @order = Order.new
  end

  def create 
    @order = Order.new(order_params)

    if @order.save 
      if session[:cart]
        session[:cart].each do |item|
          ordered_item = OrderItem.find_by(id: item['id'])
          product = Product.find_by(id: item['product_id'])
          product.remove_inventory(item['quantity'])

          ordered_item.order_id = @order.id
          @order.order_items << ordered_item
        end

        session[:cart] = []
        flash[:success] = "Your order was successfully placed!"
        redirect_to order_path(@order)
        return 
      end 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@order.name} - : #{@order.errors.messages}"
      render :new, status: :bad_request
      return
    end
  end

  def show
    @order = Order.find_by(id: params['id'])

    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end

    if @order.status == "pending"
      redirect_to cart_path
      return
    end
  end

  def mark_shipped
    order = Order.find_by(id: params['format'])
    order.mark_shipped

    if order.status == 'shipped'
      flash[:success] = "Order was successfully shipped! 😄"
      redirect_to orders_path
    end
  end

  def ordered
    @order = Order.find_by(id: params['id'])
  end

  private

  def order_params
    return params.require(:order).permit(:status, :name, :email_address, :address, :city, :state, :zipcode, :cc_num, :cc_exp_month, :cc_exp_year, :cc_cvv, :order_date, :user_id)
  end
end
