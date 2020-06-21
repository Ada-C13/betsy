require "test_helper"
require "pry"

describe OrdersController do
  let(:valid_params) {
    {
      order: {
        email: "test@gmail.com",
        address: "123  test avenue",
        cc_name: "Jane Doe",
        cc_num: 12345,
        cvv: 123,
        cc_exp: "06/2020",
        zip: 987654,
      }
    }
  }

  # TODO: FILL THIS OUT IF POSSIBLE *****
  describe "set_current_order" do
    # it "finds the correct order id for session" do
    #   we can check the session[order_id] to be set
    #   puts "HERE IS VALID_ORDER: #{valid_order.status}"
    #   expect(session[:order_id]).wont_be_nil
    #   expect(@order).wont_be_nil
    #   expect(@order.id).must_equal session[:order_id]
    # end
  end

  describe "index" do
    # CHECK REDIRECT BEHAVIOR HERE??
    it "responds with success" do
      # order = orders(:order1)
      get orders_path
      must_respond_with :redirect

      # how to test the merchant, order_collection, and total_revenue????
    end
  end

  describe "show" do
    it "responds with success" do
      order = orders(:order1)
      get order_path(order.id)
      must_respond_with :success
    end

    it "responds with success for valid orders with paid status" do
      get order_path(orders(:order2).id)
      must_respond_with :success
    end

    it "MARKS AS COMPLETE???? how to test this" do
    end
  end

  describe "edit" do
    it "responds with success" do
      order = orders(:order1)
      get edit_order_path(order.id)
      must_respond_with :success
    end
  end

  describe "update" do
    # TODO: RETURN TO THIS TEST ONCE WE KNOW WHERE TO REDIRECT
    it "updates data given valid order data, and redirects" do
      order = orders(:pending_order)
      # fields = [:email, :address, :cc_name, :cc_num, :cvv, :cc_exp, :zip]

      # fields.each do |field|
      #   expect(order.field).must_be_nil
      # end

      expect(order.email).must_be_nil

      valid_params = {
        order: {
          email: "nature@gmail.com",
          address: "1234 pine dr.",
          cc_name: "squirrel pinenut",
          cc_num: 4140837365242638,
          cvv: 123,
          cc_exp: 02/22,
          zip: 90210
        }
      }

      patch order_path(order.id), params: valid_params

      # fields.each do |field|
      #   expect(order.field).wont_be_nil
      #   expect(order.field).must_equal valid_params[:field]
      # end

      expect { 
        patch order_path(order.id), params: valid_params
      }.wont_change Order.count

      expect{order.email}.wont_be_nil
      expect(order.email).must_equal valid_params[:email]
      # must_respond_with :redirect
      # must_redirect_to
    end

    it "renders edit and bad_request status if order fails to update" do
      order = orders(:pending_order)
      puts "OUR ID IS::::::: #{order.id}"

      expect(order.email).must_be_nil

      invalid_params = {
        order: {
          id: -1,
          zip: 90210
        }
      }

      patch order_path(order.id), params: invalid_params

      expect { 
        patch order_path(order.id), params: valid_params}
      .wont_change "Order.count"

      expect(order.email).must_be_nil
      must_respond_with :redirect
      # TODO: COME BACK AND FIX THIS IS POSSIBLE ***********
      must_redirect_to edit_order_path(session[:order_id])
    end
  end

  describe "cart" do
    it "responds with success" do
      order = orders(:order1)
      get cart_path(order.id)
      must_respond_with :success
      # expect order id must be current from session
      # HOW TO TEST????
    end
  end

  describe "success" do
    it "responds with success" do
      order = orders(:order3)
      get cart_path(order.id)
      must_respond_with :success
       # expect order 3 won't be the same as current session order
      # HOW TO TEST????
    end
  end

  # LOTS TO DO HERE:::::
  describe "cancel" do
    it "does stuff" do
    end
  end
end