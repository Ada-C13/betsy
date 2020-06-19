require "test_helper"

describe Order do
  
  let (:pending_order) { orders(:order_pending) }
  let (:paid_order) { orders(:order_paid) }
  let (:complete_order) { orders(:order_complete) }
  let (:merchant1) { merchants(:suely) }
  let (:merchant2) { merchants(:annie) }
  let (:product1) { products(:tulip) }
  let (:product2) { products(:daisy) }

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

  describe "checkout_order!" do
    it "processes a valid order" do
      # Arrange
      pending_order.save!
      # Act
      result = pending_order.checkout_order!
      pending_order.reload
      # Assert
      expect(result).must_be_nil
      expect(pending_order.status).must_equal "paid"
    end

    it "rejects status not pending" do
      # Arrange
      complete_order.save!
      # Act
      result = complete_order.checkout_order!
      complete_order.reload
      # Assert
      expect(result).must_be_kind_of String
      expect(result.downcase).must_include "invalid"
      expect(complete_order.status).must_equal "complete"
    end

    it "requires a credit card" do
      # Arrange
      incomplete_order = Order.new(
        name: "Maria Lovelace", credit_card_num: nil, credit_card_exp: "12/20", credit_card_cvv: 432,
        address: "1215 4th Ave - 1050", city: "Seattle", state: "WA", zip: "98161-0001",
        customer_email: "maria@gmail.com", status: "pending"
      )
      incomplete_order.save!
      # Act
      result = incomplete_order.checkout_order!
      incomplete_order.reload
      # Assert
      expect(result).must_be_kind_of String
      expect(result.downcase).must_include "credit card"
      expect(incomplete_order.status).must_equal "pending"
    end

    it "requires a customer email" do
      # Arrange
      incomplete_order = Order.new(
        name: "Maria Lovelace", credit_card_num: 378282246310005, credit_card_exp: "12/20", credit_card_cvv: 432,
        address: "1215 4th Ave - 1050", city: "Seattle", state: "WA", zip: "98161-0001",
        customer_email: nil, status: "pending"
      )
      incomplete_order.save!
      # Act
      result = incomplete_order.checkout_order!
      incomplete_order.reload
      # Assert
      expect(result).must_be_kind_of String
      expect(result.downcase).must_include "email"
      expect(incomplete_order.status).must_equal "pending"
    end
  end # describe "checkout_order!"

  describe "ship_order!" do
    it "ships a valid order" do
      # Arrange
      paid_order.save!
      # Act
      result = paid_order.ship_order!
      paid_order.reload
      # Assert
      expect(result).must_be_nil
      expect(paid_order.status).must_equal "complete"
    end

    it "rejects status not paid" do
      # Arrange
      pending_order.save!
      # Act
      result = pending_order.ship_order!
      pending_order.reload
      # Assert
      expect(result).must_be_kind_of String
      expect(result.downcase).must_include "not paid"
      expect(pending_order.status).must_equal "pending"
    end
  end # describe "ship_order!"

  describe "cancel_order!" do
    it "cancels an order" do
      # Arrange
      paid_order.save!
      # Act
      result = paid_order.cancel_order!
      paid_order.reload
      # Assert
      expect(result).must_be_nil
      expect(paid_order.status).must_equal "cancelled"
    end

    it "rejects status not paid" do
      # Arrange
      pending_order.save!
      # Act
      result = pending_order.cancel_order!
      pending_order.reload
      # Assert
      expect(result).must_be_kind_of String
      expect(result.downcase).must_include "not paid"
      expect(pending_order.status).must_equal "pending"
    end
  end # describe "cancel_order!"

  describe "total_cost" do
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
      total = pending_order.total_cost(nil)
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
      total = pending_order.total_cost(nil)
      # Assert
      expect(total).must_be_kind_of Numeric
      expect(total).must_equal 240
    end

    it "calculates the cost per merchant" do
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

      merchant2.save!
      product2.merchant_id = merchant2.id
      product2.price = 10
      product2.save!

      item2 = OrderItem.new(
        order_id: pending_order.id,
        product_id: product2.id,
        quantity: 4
      )
      item2.save!
      # Act
      total1 = pending_order.total_cost(merchant1)
      total2 = pending_order.total_cost(merchant2)

      # Assert
      expect(total1).must_be_kind_of Numeric
      expect(total1).must_equal 200
      expect(total2).must_be_kind_of Numeric
      expect(total2).must_equal 40
    end

    it "calculates the cost for an empty order" do
      # Arrange
      paid_order.save!
      # Act
      total = paid_order.total_cost(nil)
      # Assert
      expect(total).must_be_kind_of Numeric
      expect(total).must_equal 0
    end
  end # describe "total_cost"

  describe "empty?" do
    it "returns true if there are no order items" do
      # Arrange
      pending_order.save!
      # Act
      empty = pending_order.empty?
      # Assert
      expect(empty).must_equal true
    end

    it "returns false if there are order items" do
      # Arrange
      pending_order.save!
      merchant1.save!
      product1.merchant_id = merchant1.id
      product1.save!
      item1 = OrderItem.new(
        order_id: pending_order.id,
        product_id: product1.id,
        quantity: 2
      )
      item1.save!
      # Act
      empty = pending_order.empty?
      # Assert
      expect(empty).must_equal false
    end
  end # describe "empty?"

  describe "order_items_by_merchant" do
    it "returns all order_items for a merchant" do
      # Arrange
      pending_order.save!
      merchant1.save!
      product1.merchant_id = merchant1.id
      product1.save!
      item1 = OrderItem.new(
        order_id: pending_order.id,
        product_id: product1.id,
        quantity: 2
      )
      item1.save!

      merchant2.save!
      product2.merchant_id = merchant2.id
      product2.save!
      item2 = OrderItem.new(
        order_id: pending_order.id,
        product_id: product2.id,
        quantity: 3
      )
      item2.save!
      # Act
      items = pending_order.order_items_by_merchant(merchant1)
      # Assert
      expect(items.count).must_equal 1
      expect(items.first.product_id).must_equal product1.id
    end

    it "returns no order_items if merchant has none" do
      # Arrange
      pending_order.save!
      merchant1.save!
      product1.merchant_id = merchant1.id
      product1.save!
      item1 = OrderItem.new(
        order_id: pending_order.id,
        product_id: product1.id,
        quantity: 2
      )
      item1.save!
      # Act
      items = pending_order.order_items_by_merchant(merchant2)
      # Assert
      expect(items.count).must_equal 0
    end
  end # describe "order_items_by_merchant"

end # describe Order