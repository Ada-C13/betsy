require "test_helper"

describe OrdersController do

  let (:pending_order) { orders(:order_pending) }
  let (:paid_order) { orders(:order_paid) }
  let (:complete_order) { orders(:order_complete) }

  let (:merchant1) { merchants(:suely) }
  let (:product1) { products(:tulip) }
  let (:product2) { products(:daisy) }

  before do
    pending_order.save!
    merchant1.save!

    product1.merchant_id = merchant1.id
    product1.price = 100
    product1.save!

    item1 = OrderItem.new(
      order_id: pending_order.id,
      product_id: product1.id,
      quantity: 2
    )
    item1.save!

    product2.merchant_id = merchant1.id
    product2.price = 10
    product2.save!

    item2 = OrderItem.new(
      order_id: pending_order.id,
      product_id: product2.id,
      quantity: 4
    )
    item2.save!

  end

  valid_statuses   = %w(pending paid complete cancelled)
  invalid_statuses = ["parrot", "parakeet", "incomplete", "nope", 2021, nil]

  describe "index" do
    it "succeeds when there are orders" do
      session[:user_id]  = merchant1.id
      session[:order_id] = pending_order.id
      @shopping_cart = pending_order
  
      # Act
      get orders_path

      # Assert
      must_respond_with :success
    end

    it "succeeds when there are no orders" do
      session[:user_id]  = merchant1.id
      session[:order_id] = pending_order.id
      @shopping_cart = pending_order

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
      session[:user_id]  = merchant1.id
      session[:order_id] = pending_order.id
      @shopping_cart = pending_order

      # Act
      get order_path(pending_order.id)

      # Assert
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
            session[:user_id]  = merchant1.id
      session[:order_id] = pending_order.id
      @shopping_cart = pending_order

      destroyed_id = pending_order.id
      pending_order.destroy
      
      # Act
      get order_path(destroyed_id)

      # Assert
      must_respond_with :not_found
    end
  end # describe "show"

  describe "edit" do
    it "edits the shopping cart" do

      # Act
      get cart_path

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
      must_redirect_to cart_path
    end

    it "renders bad_request for bogus data" do
      # Arrange
      updates = { order: { status: nil } }

      # Act & Assert
      expect {
        put cart_path, params: updates
      }.wont_change "Order.count"

      expect(pending_order.status).must_equal "pending"
    end
  end # describe "update"

  describe "destroy" do
    it "empties the shopping cart" do
      # Arrange
      updates = { order: {customer_email: "ada@gmail.com" } }
      put cart_path, params: updates
      old_cart_id = @shopping_cart.id

      # Act
      delete cart_path

      # Assert
      expect(@shopping_cart.id).wont_equal old_cart_id
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end # describe "destroy"

 end
