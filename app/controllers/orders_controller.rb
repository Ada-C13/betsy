class OrdersController < ApplicationController

	#GET /orders
	def index
		@orders = Order.all
		#  order = Order.all.as_json(only: [:id, :card_number,:card_expiration_date, :card_cvv, :address, :city,:zip_code, :guest_name, :email, :phone_num, :cart_status])
		# render json: order, status: :ok
	end
		
	#GET /orders/:id
	def show
		order_id = params[:id].to_i
    @order = Order.find_by_id(order_id)
  
		if @order.nil?
			head :not_found
		return
		end
	end

	def cart # show function for the open order at the moment
		if !session[:order].nil?
			open_order = Order.find_by(cart_status: true)
		end

		if !open_order.nil?
			@cart_items = open_order.order_items
		end
	end

	def checkout
		@cart = Order.find_by(cart_status: true)

		if @cart.nil? || @cart.order_items.length == 0
			flash[:error] = "Unable to checkout."
      # head :not_found
      return
		end
		
		@cart_items = @cart.order_items
	end

	def confirmation

	end

	private

	def orders_params
		return params.require(:order).permit(:guest_name, :email, :phone_num, :address, :city, :state, :zip_code, :card_number, :card_expiration_date, :card_cvv)
	end

end

