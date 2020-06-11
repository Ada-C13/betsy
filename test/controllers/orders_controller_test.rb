require "test_helper"

describe OrdersController do
  before do
    @pending_order = orders(:pending_order)
  end
  
  describe "index" do

  end

  describe "show" do
    it "responds with success when showing an existing valid order" do
      get order_path(@pending_order.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid order id" do
      get order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "checkout" do # TODO: This test is failing because there is no simple way to set session in Rails 5.x 
    it "responds with success when getting the edit page for an existing valid order" do
      build_order # see test_helper.rb
      order = Order.find(session[:order_id])
      get orders_checkout_path
      must_respond_with :success
    end

    it "responds with 404 when getting the edit page with an invalid order id" do
      get orders_checkout_path
      must_respond_with :not_found
    end
  end

  describe "update" do

  end

  describe "destroy" do

  end
end
