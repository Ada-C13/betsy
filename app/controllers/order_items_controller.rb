class OrderItemsController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :require_login

	before_action :find_order_item, only: [:update, :destroy]
	#database order_items -> use OrderItem
	#GET /order_items
	def index
		if params[:product_id] # This is the nested route, /products/:product_id/order_items
      product = Product.find_by(id: params[:product_id])
			order_items = product.order_items.as_json(only: [:id, :name, :price, :quantity])
			render json: order_items, status: :ok
    else # This is the 'regular' route, /order_items
      order_items = OrderItem.all.as_json(only: [:id, :name, :price, :quantity])
			render json: order_items, status: :ok
		end
	end
	
	#POST /order_items  { :order_item => { :name => "hello", :price => 6, }}
	def create
		@new_item = OrderItem.new(
			name: order_items_params[:name],
			price: order_items_params[:price],
			quantity: order_items_params[:quantity],
			product_id: params[:product_id],
			photo_url: order_items_params[:photo_url]
		)
		if session[:order_id]
			@open_order = Order.find_by(id: session[:order_id])
			@new_item.order_id = @open_order.id
		else
			@new_order = Order.create
			session[:order_id] = @new_order.id
			@new_item.order_id = @new_order.id
		end

		if @new_item.check_product_inventory
			@new_item.check_order_item_existence(session[:order_id])
			@new_item.reduce_inventory
			flash[:success] = 'Item added to cart.'
			redirect_to cart_path
			return
		else
			flash[:failure] = 'Not enough product inventory.'
			redirect_back fallback_location: root_path
			return
		end
	end

	# PATCH:  /order_items/:id (params)
	def update
		if @order_item.nil?
			head :not_found
			return
		elsif @order_item.update_product_inventory(order_items_params[:quantity])
			@order_item.update(order_items_params)
			flash[:success] = 'Order item quantity updated.'
			redirect_to cart_path
			return
		else
			flash[:failure] = 'Not enough inventory to update quantity.'
			redirect_to cart_path
			return
		end
	end

	# PATCH: /order_items/update_status(.:format)
	def update_status
		@order_item = OrderItem.find_by(id: params[:id])
		# raise "THIS IS ERROR"

		if @order_item.nil?
			# head :not_found
			redirect_to dashboard_path
			return
		else
			@order_item.update(fulfillment_status: params[:fulfillment_status])
			flash[:success] = 'Order item fulfillment status updated.'
			redirect_to dashboard_path
			return
		end
	end

	# DELETE  /order_items/:id
	def destroy
		if @order_item.nil?
			head :not_found
			return
		end

		@order_item.add_inventory
		@order_item.destroy

		#check if order items have a count of 0, then delete order
		count = @order_item.order.order_items.count

		if count == 0
			@order_item.order.destroy
			session[:order_id] = nil
		end

		redirect_to cart_path
		return
	end
end

private

def order_items_params
	return params.require(:order_item).permit(:name, :price, :quantity, :photo_url, :product_id, :order_id)
end

#controller filter
def find_order_item
	@order_item = OrderItem.find_by(id: params[:id])
end



