require "test_helper"

describe OrdersController do
  describe "index" do
    it "responds with success when there is at least one order item in the cart" do
      build_order # see test_helper.rb

      get cart_path
      must_respond_with :success
    end

    it "responds with success when there are no order items in the cart" do
      get cart_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing the current session order" do
      order = build_order

      get order_path(order.id)
      must_respond_with :success
    end

    it "flashes an error message and redirects if given an id that does not match session[:order_id]" do
      get order_path(-1)
      
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "cannot view"
      
      must_redirect_to root_path
    end

    it "sets the session[:order_id] to nil if the order status is paid" do
      order = build_order
      order.update(status: "paid")
      order.reload 

      get order_path(order.id)

      expect(session[:order_id]).must_be_nil
    end
  end

  describe "checkout" do
    it "responds with success and sets order status to pending when session[:order_id] exists" do
      order = build_order 

      get order_checkout_path
      must_respond_with :success

      order.reload
      expect(order.status).must_equal "pending"
    end

    it "flashes an error message and redirects to cart when session[:order_id] is nil" do
      get order_checkout_path

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "cannot check out"
      
      must_redirect_to cart_path
    end
  end

  describe "complete" do
    before do
      @order = build_order 
    end
    
    let (:order_hash) {
      {
        order: {
          name: "Wizard", 
          email: "hello@wizard.com", 
          mailing_address: "12345 Wizard Way", 
          cc_number: 1234123412341234, 
          cc_exp: Date.today + 365        
        },
      }
    }

    it "can complete an existing order with valid information accurately, create a flash message, and redirect" do
      expect {
        patch order_checkout_path, params: order_hash
      }.wont_differ "Order.count"

      @order.reload
      expect(@order.name).must_equal order_hash[:order][:name]
      expect(@order.email).must_equal order_hash[:order][:email]
      expect(@order.mailing_address).must_equal order_hash[:order][:mailing_address]
      expect(@order.cc_number).must_equal order_hash[:order][:cc_number].to_s[-4..-1].to_i
      expect(@order.cc_exp).must_equal order_hash[:order][:cc_exp]

      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_include @order.name

      must_redirect_to order_path(@order.id)
    end

    it "reduces the stock of each product by the quantity purchased" do
      # TODO: This test is failing even though the action works on the website. I tried reloading all the instances but that wasn't the issue.
      expect {
        patch order_checkout_path, params: order_hash
      }.wont_differ "Order.count"

      @order.reload
      @order.order_items.each do |item|
        expect(item.product.stock).must_equal (item.product.stock - item.quantity)
      end
    end

    it "changes the order status to paid" do
      expect {
        patch order_checkout_path, params: order_hash
      }.wont_differ "Order.count"

      @order.reload
      expect(@order.status).must_equal "paid"
    end

    it "does not complete order if the form data violates order validations, creates a flash message, and responds with a 400 error" do
      # TODO: Establish validations for Order, then come back to this test.
      invalid_order_hash = {
        order: {
          name: nil
        }
      }

      expect {
        patch order_checkout_path, params: invalid_order_hash
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include " Could not complete order"
      expect(flash[:messages].first).must_include "Name can't be blank"

      must_respond_with :bad_request
    end
  end

  describe "destroy" do

  end
end
