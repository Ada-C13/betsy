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
    it "responds with success when showing an existing valid order" do
      order = build_order

      get order_path(order.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid order id" do
      get order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "checkout" do
    it "responds with success when getting the checkout page when session[:order_id] is valid" do
      order = build_order 

      get cart_checkout_path
      must_respond_with :success
    end

    it "flashes an error message and redirects to cart when session[:order_id] is nil" do
      get cart_checkout_path

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "cannot check out"
      
      must_redirect_to cart_path
    end

    it "changes the order status to pending" do
      order = build_order

      get cart_checkout_path

      order.reload
      expect(order.status).must_equal "pending"
    end
  end

  describe "confirm order" do

  end

  describe "destroy" do

  end
end
