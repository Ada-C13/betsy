require "test_helper"

# 1nominal test
# if no session[cart_id] => create the Order PLUS create the seesion
# has session[cart_id]
# to chechk if product_id (must_be_instance_of) and prder_id (must_be_instance_of) is not empty
# clear the cart, the session[cart_id] will still exist
# if the product is already in the cart => flash message PLUS the redirect path.
# if the order_item is not saved we have to tests the flash and the redirect



# edge cases
# if we dont have quantity
# if product is nil => flash[:error] = “product is not exited”
describe OrderItemsController do
  before do
    # product1 = products(:product1)
    # order1 = orders(:full_cart)
    @order_items1 = order_items(:order_item1)
    @product = products(:product1)
  end

  describe "Guest User" do
    before do
      @order_item_data = {
        order_item: {
          quantity: @order_items1.quantity,
          status: @order_items1.status,
          product_id: @order_items1.product.id,
          order_id: @order_items1.order.id,
        }
      }
    end
    
    describe "create" do
      it "can create a new order_item with valid information accurately" do
        # binding.pry

        # before = OrderItem.count

        expect {
          post add_order_item_path(@product.id), params: @order_item_data
        }.must_differ "OrderItem.count", 1

        # expect(OrderItem.count).must_equal before + 1
        
        expect(OrderItem.last.quantity).must_equal @order_item_hash[:oder_item][:quantity]
        expect(OrderItem.last.product_id).must_equal @order_item_hash[:oder_item][:product_id]
        # expect(OrderItem.last.order_id).must_equal @order_item_hash[:oder_item][:order_id]
        expect(OrderItem.last.status).must_equal @order_item_hash[:oder_item][:status]

        must_respond_with :redirect
      end

    end
  end

  # describe "Logged In Merchant" do 
  #   before do
  #     @merchant = merchants(:merchantaaa)
  #     perform_login(@merchant)
  #   end


  # end

end
