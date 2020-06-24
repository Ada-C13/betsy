require "test_helper"

describe OrdersController do
  before do
    @order1 = Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)  
    @order2 = Order.create(status: "pending")
    @user = User.create(name: "camden", email_address: "camden@ajonisle.com", uid: 666)
    @product = Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: @user.id)
    @orderitem = OrderItem.create(order_id: @order1.id, product_id: @product.id, quantity: 1)
    login(@user)
  end

  describe "index" do
    it "gets all of the users orders" do
      
    end

    it "gets all of the users products" do

    end
  end

  describe "new" do
    it "gets the new order path" do
      get new_order_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new order" do

      order_params = {
        order: {
          status: "pending",
          name: "Owl", 
          email_address: "owl@nooksy.com", 
          address: "222 Waterfall Way", 
          city: "Ajon", 
          state: "HI", 
          zipcode: "22222", 
          cc_num: "1234567890123", 
          cc_exp_month: "12", 
          cc_exp_year: "2023", 
          cc_cvv: "123", 
          order_date: Time.now
        }
      }

      order_item_params = {
        quantity: 2,
        product_id: products(:pengsoo_nose).id,
        order_id: @order1.id
      }

      post orderitems_path, params: order_item_params


      expect {post orders_path, params: order_params}.must_change "Order.count", 1

      order = Order.last
      
      expect(order.status).must_equal "pending"
      expect(session[:cart]).must_be_instance_of Array

      expect(session[:cart].length).must_equal 0
      
      must_respond_with :redirect
      must_redirect_to order_path(order)
      expect(flash[:success]).must_equal "Your order was successfully placed!"
    end

    it "removes the appropriate inventory from the product" do
      get cart_path
      @order1.save

      product = Product.find_by(id: @product.id)

      expect(product.inventory).must_equal 2
      product.remove_inventory(1)

      expect(product.inventory).must_equal 1
    end

    it "lets user know when a problem occurred" do
      order_params = {
        order: {
          name: nil, 
          email_address: "marina@ajonisle.com", 
          address: "222 Waterfall Way", 
          city: "Ajon", 
          state: "HI", 
          zipcode: "22222", 
          cc_num: "1234567890123", 
          cc_exp_month: "12", 
          cc_exp_year: "2023", 
          cc_cvv: "123", 
          order_date: Time.now
        }
      }
      
      expect {post orders_path, params: order_params}.wont_change "Order.count"

      order = Order.last

      expect(flash[:error]).must_include "A problem occurred: Could not update"
      must_respond_with :bad_request
      assert_template :new
    end
  end

  describe "show" do
    it "redirects if order is nil" do
      invalid_id = -3

      get order_path(invalid_id)

      must_respond_with :redirect
    end

    it "redirects if order.status is 'pending'" do
      get order_path(@order2.id)

      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end

  describe "mark_shipped" do
    it "marks an items status as shipped and gives success" do
      patch mark_shipped_path(@order1.id)
      
      found_order = Order.find(@order1.id)
      expect(found_order.status).must_equal "shipped"

      expect(flash.now[:success]).must_equal "Order was successfully shipped! 😄"
      must_respond_with :redirect
      must_redirect_to orders_path
    end
  end
end
