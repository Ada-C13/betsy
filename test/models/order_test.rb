require "test_helper"

describe Order do

  let (:new_customer) { Customer.new(email: "jane@gmail.com") }
  let (:new_order) { Order.new(customer_id: new_customer.id, status: "pending") }

  describe "relations" do
      
    it "has a customer" do
      new_customer.save!
      new_order.save!
      expect(new_order).must_respond_to :customer
      expect(new_order.customer).must_be_kind_of Customer
    end

    it "has a list of order_items" do
      # TODO add order_items here when available
      # TODO remove comments when order_item relationship available
      new_customer.save!
      new_order.save!
      expect(new_order).must_respond_to :orderitems
      # new_order.orderitems.each do |order_item|
      #   expect(order_item).must_be_kind_of OrderItem
      # end
    end
  end # describe "relations"

  describe "validations" do
    it "allows the four status" do
      new_customer.save!
      valid_statuses = %w(pending paid complete cancelled)
      valid_statuses.each do |status|
        order = Order.new(customer_id: new_customer.id, status: status)
        expect(order.valid?).must_equal true
      end
    end

    it "rejects invalid statuses" do
      new_customer.save!
      invalid_statuses = ["parrot", "parakeet", "incomplete", 2020, nil]
      invalid_statuses.each do |status|
        order = Order.new(customer_id: new_customer.id, status: status)
        expect(order.valid?).must_equal false
        expect(order.errors.messages).must_include :status
      end
    end
  end # describe "validations"

end
