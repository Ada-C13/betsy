require "test_helper"

describe OrdersController do
  before do
    @order = Order.create!
  end
  
  describe "show" do
    it "responds with success when showing an existing valid order" do
      order = Order.create!
      get order_path(order.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid order id" do
      get order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "create" do

  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing valid order" do
      order = Order.create!
      get edit_order_path(order.id)
      must_respond_with :success
    end

    it "responds with 404 when getting the edit page with an invalid order id" do
      get edit_order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do

  end

  describe "destroy" do

  end
end
