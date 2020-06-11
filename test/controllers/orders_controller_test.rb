require "test_helper"

describe OrdersController do

  let(:existing_order) { Order.new(status: "pending") }
  valid_statuses   = %w(pending paid complete cancelled)
  invalid_statuses = ["parrot", "parakeet", "incomplete", "nope", 2021, nil]

  describe "index" do
    it "succeeds when there are orders" do
      # Arrange
      existing_order.save!

      # Act
      get orders_path

      # Assert
      must_respond_with :success
    end

    it "succeeds when there are no orders" do
      # Arrange
      Order.all do |order|
        order.destroy
      end

      # Act
      get orders_path

      # Assert
      must_respond_with :success
    end
  end # describe "index"

  describe "show" do
    it "succeeds for an existing order ID" do
      # Arrange
      existing_order.save!

      # Act
      get order_path(existing_order.id)

      # Assert
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      destroyed_id = existing_order.id
      existing_order.destroy
      
      # Act
      get order_path(destroyed_id)

      # Assert
      must_respond_with :not_found
    end
  end # describe "show"

  describe "edit" do
    it "edits the shopping cart" do

      # Act
      get edit_order_path

      # Assert
      must_respond_with :success
    end
  end # describe "edit"

  describe "update" do
    it "updates the shopping cart" do
      # Arrange
      updates = { order: {customer_email: "ada@gmail.com" } }

      # Act & Assert
      expect {
        put orders_path, params: updates
      }.wont_change "Order.count"

      expect(@shopping_cart.customer_email).must_equal "ada@gmail.com"
      must_respond_with :redirect
      must_redirect_to order_path(existing_order.id)
    end

    it "renders bad_request for bogus data" do
      # Arrange
      updates = { order: { status: nil } }

      # Act & Assert
      expect {
        put orders_path, params: updates
      }.wont_change "Order.count"

      expect(existing_order.status).must_equal "pending"
    end
  end # describe "update"

  describe "destroy" do
    it "empties the shopping cart" do
      # Arrange
      updates = { order: {customer_email: "ada@gmail.com" } }
      put orders_path, params: updates
      old_cart_id = @shopping_cart.id

      # Act
      delete orders_path

      # Assert
      expect(@shopping_cart.id).wont_equal old_cart_id
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end # describe "destroy"

 end
