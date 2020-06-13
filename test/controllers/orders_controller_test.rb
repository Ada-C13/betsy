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
  end

  describe "checkout" do
    it "responds with success and sets order status to pending when session[:order_id] exists" do
      order = build_order 

      get cart_checkout_path
      must_respond_with :success

      order.reload
      expect(order.status).must_equal "pending"
    end

    it "flashes an error message and redirects to cart when session[:order_id] is nil" do
      get cart_checkout_path

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "cannot check out"
      
      must_redirect_to cart_path
    end
  end

  describe "confirm order" do

  end

  describe "destroy" do

  end
end
