require "test_helper"

describe OrdersController do
  # describe "index" do
  #   it "responds with success when there is at least one order item in the cart" do
  #     build_order # see test_helper.rb

  #     get orders_path
  #     must_respond_with :success
  #   end

  #   it "responds with success when there are no order items in the cart" do
  #     get orders_path
  #     must_respond_with :success
  #   end
  # end

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
    it "responds with success when getting the edit page for an existing valid order" do
      order = build_order # see test_helper.rb

      get order_checkout_path
      must_respond_with :success
    end

    it "responds with 404 when getting the edit page with an invalid order id" do
      get order_checkout_path
      must_respond_with :not_found
    end
  end

  describe "update" do

  end

  describe "destroy" do

  end
end
