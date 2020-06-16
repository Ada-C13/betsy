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

# expect(session[:merchant_id]).must_equal merchant.id

describe OrdersController do
  # before do
  #   # @order1 = orders(:full_cart)
  #   session[:cart_id] = @order1.id
  # end

  # name: 
  # email: 
  # address: 
  # cc_last_four: 
  # cc_exp_month:
  # cc_exp_year:
  # cc_cvv:
  # status: pending

  describe "Guest User" do
    describe "create order" do
      it "create new Order and track it's session id" do
        get cart_path
        # how should create a session == nil, in order to trigger the Order creation?
        expect(session[:cart_id]).must_equal Order.last.id
      end

      it "adding items to the existing session if there is one" do
        get cart_path

        expect(session[:cart_id]).must_equal Order.last.id
        order_exist = Order.last.id

        get cart_path

        expect(session[:cart_id]).must_equal order_exist
      end
    end
    
    describe "clear_cart" do
      it "remove all orderitems from the cart" do
        # Arrange
        # @order = orders(:full_cart) # which has 2 items in it
        # @order = orders(:full_cart)
        # session = @order.id

        

        # n = Order.find_by(id: session[:cart_id])
        # p n
      
        # p session[:cart_id]
        # @order = orders(:full_cart)
        # session[:card_id] = orders(:full_cart).id
        # p @order.order_items
        # # Act
        # patch cart_path
        # # Assert
        # p @order.order_items
        # expect(@order.order_items.size).must_equal 0
        # p @order

        order1 = {
          order: {
          name: nil,
          email: nil,
          address: nil,
          cc_last_four: nil,
          cc_cvv: nil,
          status: "pending",
          cc_exp_month: nil,
          cc_exp_year: nil
          }
        }
      
        get cart_path

        expect(session[:cart_id]).must_equal order1.id

        patch cart_path
        # p @order.order_items.size
        expect(session[:cart_id]).must_equal_nil
        
        # Act
        # session[:cart_id] = @order.id

        # result = @order.clear_cart

        # p controller.session[:cart_id]
        
        # Assert
        # p order.order_items
        # expect(order.order_items.size).must_equal 0
        # session[:cart_id] = @order.id
        # @order.order_items.each do |order_item|
        #   order_item.destroy
        # end
        

        # expect(orders(:full_cart).order_items.size).must_equal 0
        
        # must_redirect_to cart_path
      end
    end

    # describe "submit_order" do
    #   it "" do  
    #     # Arrange
    #     order = orders(:full_cart) # which has 2 items in it
    #     # Act
    #     patch '/cart/checkout' # to: "orders#submit_order"
    #     # Assert
    #     #  
    #   end
    # end

  
  



    # else
    #   @order = Order.new
    #   if @order.save
    #     session[:cart_id] = @order.id

  end

  #   it "Order status change to paid "

  # end


  # describe "Logged In Merchant" do 
   
  
end
