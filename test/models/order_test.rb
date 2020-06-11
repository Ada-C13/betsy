require "test_helper"

describe Order do

  # Arrange
  let (:new_order) { Order.new(status: "pending") }

  describe "relations" do
    it "has a list of order_items" do
      # Arrange & Act
      new_order.save!

      # Assert
      expect(new_order).must_respond_to :order_items

      new_order.order_items.each do |orderitem|
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

  describe "process_payment" do
    it "processes a valid payment" do
      # Arrange
      new_order.credit_card_num = 1234
      new_order.credit_card_exp = "12/20"
      new_order.credit_card_cvv = 432
      new_order.customer_email  = "ada@gmail.com"
      new_order.save!

      # Act
      result = new_order.process_payment!
      new_order.reload

      # Assert
      expect(result).must_equal true
      expect(new_order.status).must_equal "paid"
    end

    it "rejects status not pending" do
      # Arrange
      new_order.credit_card_num = 1234
      new_order.credit_card_exp = "12/20"
      new_order.credit_card_cvv = 432
      new_order.customer_email  = "ada@gmail.com"
      new_order.status = "cancelled"
      new_order.save!

      # Act
      result = new_order.process_payment!
      new_order.reload

      # Assert
      expect(result).must_equal false
      expect(new_order.status).must_equal "cancelled"
    end

    it "requires a credit card" do
      # Arrange
      new_order.credit_card_num = nil
      new_order.credit_card_exp = "12/20"
      new_order.credit_card_cvv = 432
      new_order.customer_email  = "ada@gmail.com"
      new_order.save!

      # Act
      result = new_order.process_payment!
      new_order.reload

      # Assert
      expect(result).must_equal false
      expect(new_order.status).must_equal "pending"
    end

    it "requires a customer email" do
      # Arrange
      new_order.credit_card_num = 5555
      new_order.credit_card_exp = "12/20"
      new_order.credit_card_cvv = 432
      new_order.customer_email  = ""
      new_order.save!

      # Act
      result = new_order.process_payment!
      new_order.reload

      # Assert
      expect(result).must_equal false
      expect(new_order.status).must_equal "pending"
    end
  end # describe "process_payment"

  describe "complete_order" do
    it "completes a valid order" do
      # Arrange
      new_order.status = "paid"
      new_order.save!

      # Act
      result = new_order.complete_order!
      new_order.reload

      # Assert
      expect(result).must_equal true
      expect(new_order.status).must_equal "complete"
    end

    it "rejects status not paid" do
      # Arrange
      new_order.save!

      # Act
      result = new_order.complete_order!
      new_order.reload

      # Assert
      expect(result).must_equal false
      expect(new_order.status).must_equal "pending"
    end
  end # describe "complete_order"

  describe "cancel_order" do
    it "cancels an order" do
      # Arrange
      new_order.status = "paid"
      new_order.save!

      # Act
      result = new_order.cancel_order!
      new_order.reload

      # Assert
      expect(result).must_equal true
      expect(new_order.status).must_equal "cancelled"
    end
  end # describe "cancel_order"

end # describe Order