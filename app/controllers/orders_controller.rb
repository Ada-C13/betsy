class OrdersController < ApplicationController
	skip_before_action :require_login, except: [:show, :index]
	before_action :find_cart_order, only: [:cart, :checkout, :confirmation]
	#GET /orders
	def index
		@orders = Order.all
	end
		
	#GET /orders/:id
	def show
		@order = Order.find_by(id: params[:id])
		
		if @order.nil?
			head :not_found
			return
		end

		@merchant_items = []

		@order.order_items.each do |order_item|
			if order_item.product.merchant_id == session[:user_id]
				@merchant_items << order_item
			end
		end
	end

	def update
		@open_order = nil
		
		if !session[:order_id].nil?
			@open_order = Order.find_by(id: session[:order_id])
		else
			@open_order = Order.find_by(id: params[:id])
		end
		
		if @open_order.nil?
			head :not_found
			return
		elsif @open_order.update(orders_params)
			redirect_to confirmation_path
      return
		else
			flash[:error] = 'Order could not be placed.'
			redirect_to checkout_path
      return
    end
	end

	def cart # show function for the open order at the moment
		if !session[:order_id].nil?
			@open_order = Order.find_by(id: session[:order_id])
		end

		if !@open_order.nil?
			@cart_items = @open_order.order_items
		end
	end

	def checkout
		if @cart.nil? || @cart.order_items.length == 0		
			flash[:failure] = "Unable to checkout."
			redirect_to cart_path
      return
		end
		
		@cart_items = @cart.order_items
	end

	def confirmation
		if @cart.nil? || @cart.order_items.length == 0
			flash[:error] = "Unable to checkout."
			redirect_to cart_path
			return
		end

		@cart_items = @cart.order_items
		@cart.purchase_changes
		session[:order_id] = nil
	end

	private

	def orders_params
		return params.require(:order).permit(:guest_name, :email, :phone_num, :address, :city, :state, :zip_code, :card_number, :card_expiration_date, :card_cvv)
	end

	#controller filter
	def find_cart_order
  	@cart = Order.find_by(id: session[:order_id])
	end

end

