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

  describe "checkout" do
    it "responds with success when getting the edit page for an existing valid order" do
      order = build_order # see test_helper.rb

      get order_checkout_path(order)
      must_respond_with :success
    end

    it "responds with 404 when getting the edit page with an invalid order id" do
      get order_checkout_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do

  end

  describe "destroy" do

  end
end
