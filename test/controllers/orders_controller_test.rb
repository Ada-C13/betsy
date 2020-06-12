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
      merchant = perform_login(merchants(:angela))
      # Act
      get orders_path
      # Assert
      must_respond_with :success
    end

    it "succeeds when there are no orders" do
      merchant = perform_login(merchants(:angela))
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
      # Act
      get order_path(pending_order.id)
      # Assert
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      # Arrange
      destroyed_id = pending_order.id
      pending_order.destroy
      # Act
      expect {
        get order_path(destroyed_id)
      }.must_raise ActionController::RoutingError
      # Assert
      # must_respond_with :not_found
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
      # Act 
      post cart_path, params: updates
      cart = Order.last
      # Assert
      expect(cart.customer_email).must_equal "ada@gmail.com"
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "renders bad_request for bogus data" do
      # Arrange
      updates = { order: { status: nil } }
      # Act & Assert
      post cart_path, params: updates
      cart = Order.last
      expect(cart.status).must_equal "pending"
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

  describe "pay" do # TODO add tests
    it "successfully pays for a order" do # nominal case
      skip
    # if @shopping_cart.checkout_order!
    #   session[:order_id] = nil
    #   flash[:status] = :success
    #   flash[:result_text] = "Successfully paid order #{@shopping_cart.id}"
    # else
    #   flash[:status] = :failure
    #   flash[:result_text] = "Payment processing failed!"
    # end
    # redirect_to order_path(@shopping_cart)
    end

    it " " do # edge case
      skip
    end
  end # describe "pay"

  describe "complete" do # TODO add tests

    # order = Order.find_by(id: params[:id])
    # if order.ship_order!
    #   flash[:status] = :success
    #   flash[:result_text] = "Successfully completed order #{order.id}"
    # else
    #   flash[:status] = :failure
    #   flash[:result_text] = "Failed to complete the order."
    # end
    # redirect_back fallback_location: order_path(order)
    it " " do # nominal case
      skip
    end    

    it " " do # edge case
      skip
    end    
  end # describe "complete"

  describe "cancel" do  # TODO add tests

    #   order = Order.find_by(id: params[:id])
    #   if order.cancel_order!
    #     flash[:status] = :success
    #     flash[:result_text] = "Successfully cancelled order #{order.id}"
    #   else
    #     flash[:status] = :failure
    #     flash[:result_text] = "Failed to cancel order."
    #   end
    #   redirect_back fallback_location: order_path(order)
    it " " do # nominal case
      skip
    end    

    it " " do # edge case
      skip
    end    
  end # describe "cancel"

end # describe OrdersController