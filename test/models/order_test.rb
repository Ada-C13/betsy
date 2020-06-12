require "test_helper"

describe Order do

  # Arrange
  let (:pending_order) { orders(:order_pending) }
  let (:paid_order) { orders(:order_paid) }
  let (:complete_order) { orders(:order_complete) }

  describe "relations" do
    it "has a list of order_items" do
      # Arrange & Act
      pending_order.save!

      # Assert
      expect(pending_order).must_respond_to :order_items

      pending_order.order_items.each do |orderitem|
        expect(orderitem).must_be_kind_of OrderItem
      end
    end
  end # describe "relations"

  describe "validations" do
    it "allows the four status" do
      # Arrange
      valid_statuses = %w(pending paid complete cancelled)
      valid_statuses.each do |status|
        # Act
        order = Order.new(status: status)
        # Assert
        expect(order.valid?).must_equal true
      end
    end

    it "rejects invalid statuses" do
      # Arrange
      invalid_statuses = ["parrot", "parakeet", "incomplete", 2020, nil]
      invalid_statuses.each do |status|
        # Act
        order = Order.new(status: status)
        # Assert
        expect(order.valid?).must_equal false
        expect(order.errors.messages).must_include :status
      end
    end
  end # describe "validations"

  describe "checkout_order" do
    it "processes a valid order" do
      # Arrange
      pending_order.save!

      # Act
      result = pending_order.checkout_order!
      pending_order.reload

      # Assert
      expect(result).must_equal true
      expect(pending_order.status).must_equal "paid"
    end

    it "rejects status not pending" do
      # Arrange
      complete_order.save!

      # Act
      result = complete_order.checkout_order!
      complete_order.reload

      # Assert
      expect(result).must_equal false
      expect(complete_order.status).must_equal "complete"
    end

    it "requires a credit card" do
      # Arrange
      pending_order.credit_card_num = nil
      pending_order.save!

      # Act
      result = pending_order.checkout_order!
      pending_order.reload

      # Assert
      expect(result).must_equal false
      expect(pending_order.status).must_equal "pending"
    end

    it "requires a customer email" do
      # Arrange
      pending_order.customer_email  = ""
      pending_order.save!

      # Act
      result = pending_order.checkout_order!
      pending_order.reload

      # Assert
      expect(result).must_equal false
      expect(pending_order.status).must_equal "pending"
    end
  end # describe "checkout_order"

  describe "ship_order" do
    it "ships a valid order" do
      # Arrange
      paid_order.save!

      # Act
      result = paid_order.ship_order!
      paid_order.reload

      # Assert
      expect(result).must_equal true
      expect(paid_order.status).must_equal "complete"
    end

    it "rejects status not paid" do
      # Arrange
      pending_order.save!

      # Act
      result = pending_order.ship_order!
      pending_order.reload

      # Assert
      expect(result).must_equal false
      expect(pending_order.status).must_equal "pending"
    end
  end # describe "ship_order"

  describe "cancel_order" do
    it "cancels an order" do
      # Arrange
      paid_order.save!

      # Act
      result = paid_order.cancel_order!
      paid_order.reload

      # Assert
      expect(result).must_equal true
      expect(paid_order.status).must_equal "cancelled"
    end
  end # describe "cancel_order"

  describe "total_cost" do
    # Arrange
    let (:merchant1) { merchants(:suely) }
    let (:product1) { products(:tulip) }
    let (:product2) { products(:daisy) }

    it "calculates the cost for a one product order" do
      # Arrange
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

      # Act
      total = pending_order.total_cost

      # Assert
      expect(total).must_be_kind_of Numeric
      expect(total).must_equal 200
    end

    it "calculates the cost for a two product order" do
      # Arrange
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

      # Act
      total = pending_order.total_cost

      # Assert
      expect(total).must_be_kind_of Numeric
      expect(total).must_equal 240
    end

    it "calculates the cost for an empty order" do
      # Arrange
      paid_order.save!

      # Act
      total = paid_order.total_cost

      # Assert
      expect(total).must_be_kind_of Numeric
      expect(total).must_equal 0
    end
  end # describe "total_cost"

end # describe Order