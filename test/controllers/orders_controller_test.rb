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

    it "flashes an error message and redirects if given a merchant that does not match session[:merchant_id]" do
      merchant = perform_login
      order = orders(:complete_order)
      get order_path(order.id)
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "This order does not have your products"
      must_redirect_to root_path
    end

    it "flashes an error message and redirects if given the order does not exist" do
      get order_path(-1)
      
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "Sorry, there is no such order"
      
      must_redirect_to root_path
    end

    it "flashes an error message and redirects if given an id that does not match session[:order_id]" do
      order = build_order
      get order_path(orders(:paid_order))
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "You cannot view this order!"
      must_redirect_to root_path
    end
  end

  describe "complete" do
    before do
      @product_1 = products(:apple)
      @product_2 = products(:mango)
      @order = build_order(@product_1, @product_2) 
    end
    
    let (:order_hash) {
      {
        order: {
          name: "Wizard", 
          email: "hello@wizard.com", 
          mailing_address: "12345 Wizard Way", 
          cc_number: 1234123412341234, 
          cc_exp: Date.today + 365,
          cvv: 123,
          zipcode: 12345        
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
      expect(@order.cc_number).must_equal order_hash[:order][:cc_number]
      expect(@order.cc_exp).must_equal order_hash[:order][:cc_exp]
      expect(@order.cvv).must_equal order_hash[:order][:cvv]
      expect(@order.zipcode).must_equal order_hash[:order][:zipcode]

      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_include @order.name

      must_redirect_to order_confirmation_path(@order.id)
    end

    it "reduces the stock of each product by the quantity purchased" do
      expect {
        patch order_checkout_path, params: order_hash
      }.wont_differ "Order.count"
      
      @order.products.each do |product|
        expect(product.stock).must_equal 4
      end
    end

    it "changes the order status to paid, and sets purchase date" do
      expect {
        patch order_checkout_path, params: order_hash
      }.wont_differ "Order.count"

      @order.reload
      expect(@order.status).must_equal "paid"
      expect(@order.purchase_date).must_equal Date.today
    end

    it "does not complete order if the form data violates order validations, creates a flash message, and responds with a 400 error" do
      invalid_order_hash = {
        order: {
          name: nil
        }
      }

      expect {
        patch order_checkout_path, params: invalid_order_hash
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_equal "Could not complete order!"
      expect(flash[:messages].first).must_include ["can't be blank"]

      must_respond_with :bad_request
    end
  end

  describe "confirmation" do
    it "responds with success when showing the current session order" do
      order = build_order

      get order_confirmation_path(order.id)
      must_respond_with :success
    end

    it "flashes an error message and redirects if given an id that does not match session[:order_id]" do
      get order_confirmation_path(-1)
      
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "cannot view"
      
      must_redirect_to root_path
    end

    it "sets the session[:order_id] to nil if the order status is paid" do
      order = build_order
      
      order_hash = {
        order: {
          name: "Wizard", 
          email: "hello@wizard.com", 
          mailing_address: "12345 Wizard Way", 
          cc_number: 1234123412341234, 
          cc_exp: Date.today + 365,
          cvv: 123,
          zipcode: 12345      
        },
      }
      
      patch order_checkout_path, params: order_hash

      get order_confirmation_path(order.id)

      order.reload
      expect(order.status).must_equal "paid"
      expect(session[:order_id]).must_be_nil
    end
  end

  describe "destroy" do
    it "can cancel the order when given a valid id, creates a flash message, then redirects" do
      order = build_order

      expect{
        delete order_path(order)
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_include "#{order.id}"

      must_redirect_to root_path
    end

    it "does not cancel the order when given an invalid id, then responds with a 404 error" do
      expect{
        delete order_path(-1)
      }.wont_differ "Order.count"

      must_respond_with :not_found
    end

    it "can add the quantity of each order item back to product stock" do
      product1 = products(:plant)
      product2 = products(:ball)
      order = build_order(product1, product2)

      expect{
        delete order_path(order)
      }.wont_differ "Order.count"

      order.products.each do |product|
        expect(product.stock).must_equal 6
      end
    end

    it "sets order status to cancelled" do
      order = build_order
      order.update(
        name: "Wizard", 
        email: "hello@wizard.com", 
        mailing_address: "12345 Wizard Way", 
        cc_number: 1234123412341234, 
        cc_exp: Date.today + 365,
        cvv: 123,
        zipcode: 12345
      )

      expect{
        delete order_path(order)
      }.wont_differ "Order.count"

      order.reload
      expect(order.status).must_equal "cancelled"
    end
  end

  describe "search form" do
    it "responds with success" do
      get orders_search_new_path
      must_respond_with :success
    end
  end
  
  describe "search" do
    before do
      @order = orders(:pending_order)
    end

    let (:search_hash) {
      {
        id: @order.id,
        email: @order.email,
      }
    }

    it "can successfully find an order given an existing id and email address, flashes a success message, and redirects" do
      expect{
        post orders_search_path, params: search_hash
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_include "Order found!"

      must_redirect_to orders_found_path(@order.id)
    end

    it "flashes an error message and redirects if given an invalid id" do
      search_hash[:id] = -1

      expect{
        post orders_search_path, params: search_hash
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "Order not found!"
      
      must_respond_with :not_found
    end

    it "flashes an error message and redirects if given an invalid email" do
      search_hash[:email] = nil
      
      expect{
        post orders_search_path, params: search_hash
      }.wont_differ "Order.count"

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "Order not found!"

      must_respond_with :not_found
    end
  end

  describe "found" do
    it "responds with success when showing an existing valid order" do
      order = orders(:pending_order)
      
      get orders_found_path(order.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid order id" do
      get orders_found_path(-1)
      must_respond_with :not_found
    end
  end
end
