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
      # Arrange
      merchant = perform_login(merchants(:suely))
      # Act
      get orders_path
      # Assert
      must_respond_with :success
    end

    it "succeeds when there are no orders" do
      # Arrange
      merchant = perform_login(merchants(:suely))
      Order.all do |order|
        order.destroy
      end
      # Act
      get orders_path
      # Assert
      must_respond_with :success
    end

    it "fails if no merchant is logged in" do
      # Act
      get orders_path
      # Assert
      must_redirect_to root_path
    end    
  end # describe "index"

  describe "show" do
    it "succeeds for an existing order ID" do
      # Arrange
      merchant = perform_login(merchants(:suely))
      # Act
      get order_path(pending_order.id)
      # Assert
      must_respond_with :success
    end

    it "redirects to order list if order not found" do
      # Arrange
      merchant = perform_login(merchants(:suely))
      destroyed_id = pending_order.id
      pending_order.destroy
      # Act
      get order_path(destroyed_id)
      # Assert
      must_redirect_to orders_path
    end

    it "redirects to root if merchant not logged in" do
      # Act
      get order_path(pending_order.id)
      # Assert
      must_redirect_to root_path
    end    
  end # describe "show"

  describe "edit" do
    it "edits the shopping cart" do
      # Arrange
      # @shopping_cart created automatically
      # Act
      get cart_path
      # Assert
      must_respond_with :success
    end
  end # describe "edit"

  describe "update" do
    it "successfully checks out an order" do
      # Arrange
      get cart_path
      updates = { 
        order: {
          name: "Julia Lovelace", credit_card_num: 378282246310005,
          credit_card_exp: "12/20", credit_card_cvv: 432,
          address: "1215 4th Ave - 1050", city: "Seattle", state: "WA", zip: "98161-0001",
          customer_email: "julia@gmail.com"
        }
      }
      # Act
      patch cart_path, params: updates
      order = Order.last
      # Assert
      expect(order.status).must_equal "paid"
      must_respond_with :redirect 
      must_redirect_to order_confirmation_path(order)
    end

    it "checkout fails if payment data is missing" do
      # Arrange
      get cart_path
      updates = { 
        order: {
          address: "1215 4th Ave - 1050", city: "Seattle", state: "WA", zip: "98161-0001",
          customer_email: "julia@gmail.com"
        }
      }
      # Act
      patch cart_path, params: updates
      order = Order.last
      # Assert
      expect(order.status).must_equal "pending"
      must_respond_with :bad_request
    end

    it "checkout fails if address data is missing" do
      # Arrange
      get cart_path
      updates = { 
        order: {
          name: "Julia Lovelace", credit_card_num: 378282246310005,
          credit_card_exp: "12/20", credit_card_cvv: 432,
          customer_email: "julia@gmail.com"
        }
      }
      # Act
      patch cart_path, params: updates
      order = Order.last
      # Assert
      expect(order.status).must_equal "pending"
      must_respond_with :bad_request
    end

    it "checkout fails if email data is missing" do
      # Arrange
      get cart_path
      updates = { 
        order: {
          name: "Julia Lovelace", credit_card_num: 378282246310005,
          credit_card_exp: "12/20", credit_card_cvv: 432,
          address: "1215 4th Ave - 1050", city: "Seattle", state: "WA", zip: "98161-0001"
        }
      }
      # Act
      patch cart_path, params: updates
      order = Order.last
      # Assert
      expect(order.status).must_equal "pending"
      must_respond_with :bad_request
    end
  end # describe "update"

  describe "destroy" do
    it "empties the shopping cart" do
      # Arrange
      get cart_path
      old_cart = Order.last
      # Act
      delete cart_path
      new_cart = Order.last
      # Assert
      expect(old_cart.id).wont_equal new_cart.id
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end # describe "destroy"

  describe "complete" do
    it "successfully ships a paid order" do
      # Act
      post order_complete_path(paid_order)
      paid_order.reload
      # Assert
      expect(paid_order.status).must_equal "complete"
      must_respond_with :redirect 
      must_redirect_to order_path(paid_order)
    end

    it "fails to ship a pending order" do
      # Act
      post order_complete_path(pending_order)
      pending_order.reload
      # Assert
      expect(pending_order.status).must_equal "pending"
      must_respond_with :redirect 
      must_redirect_to order_path(pending_order)
    end
  end # describe "complete"

  describe "cancel" do
    it "successfully cancels a paid order" do
      # Act
      post order_cancel_path(paid_order)
      paid_order.reload
      # Assert
      expect(paid_order.status).must_equal "cancelled"
      must_respond_with :redirect 
      must_redirect_to order_path(paid_order)
    end

    it "fails to cancel a complete order" do
      # Act
      post order_cancel_path(complete_order)
      complete_order.reload
      # Assert
      expect(complete_order.status).must_equal "complete"
      must_respond_with :redirect 
      must_redirect_to order_path(complete_order)
    end
  end # describe "cancel"

  describe "confirmation" do
    it "succeeds for a valid order ID" do
      # Arrange
      # in the before block
      # Act
      get order_confirmation_path(paid_order.id)
      # Assert
      must_respond_with :success
    end

    it "redirects to order list if order not found" do
      # Arrange
      destroyed_id = paid_order.id
      paid_order.destroy
      # Act
      get order_confirmation_path(destroyed_id)
      # Assert
      must_redirect_to orders_path
    end
  end # describe "confirmation"

end # describe OrdersController