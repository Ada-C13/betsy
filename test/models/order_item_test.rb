require "test_helper"

describe OrderItem do
  before do
    @new_product = products(:product1)
    @new_order = orders(:full_cart)
  end

  let (:new_order_item) {
    OrderItem.new(
      quantity: 2, 
      status: "pending",
      product_id: @new_product.id,
      order_id: @new_order.id,
    )
  }

  it "OrderItem can be instantiated" do
    expect(new_order_item.valid?).must_equal true
  end

  it "OrderItem has required fields" do
    # Arrange
    new_order_item.save
    [:quantity, :status].each do |field|
      # Assert
      expect(new_order_item).must_respond_to field
    end
  end

  describe "belongs_to relationship" do
    before do
      # get order items from the fixture
      @order_items = order_items
    end

    it "order_item belongs to a product" do
      @order_items.each do |order_item|
        expect(order_item.product).must_be_instance_of Product
      end
    end

    it "order_item belongs to a order" do
      @order_items.each do |order_item|
        expect(order_item.order).must_be_instance_of Order
      end
    end
  end

  describe "validation" do
    it "order_item must have a quantity" do
      # Arrange
      new_order_item.quantity = nil
      # Assert
      expect(new_order_item.valid?).must_equal false
      expect(new_order_item.errors.messages).must_include :quantity
      expect(new_order_item.errors.messages[:quantity]).must_include "can't be blank"
      expect(new_order_item.errors.messages[:quantity]).must_include "is not a number"
    end

    it "it's valid when order_item has quantity" do
      expect(new_order_item.valid?).must_equal true
    end

    it "order_item must have a status" do
      # Arrange
      new_order_item.status = nil
      # Assert
      expect(new_order_item.valid?).must_equal false
      expect(new_order_item.errors.messages).must_include :status
      expect(new_order_item.errors.messages[:status]).must_include "can't be blank"
      expect(new_order_item.errors.messages[:status]).must_include "Not a valid status"
    end

    it "it's valid when order_item has status" do
      expect(new_order_item.valid?).must_equal true
    end
  end

  describe "restock" do
    it "rejects restocking an item that's already shipped" do
      item = OrderItem.find_by(status: "shipped")
      result = item.restock
      expect(result).must_equal false
      expect(item.errors.messages[:status]).must_include "This item is already shipped"
    end
    it "changes item status to cancelled" do
      item = OrderItem.find_by(status: "paid")
      result = item.restock
      expect(result).must_equal true
      expect(item.status).must_equal "cancelled"
    end
    it "item product stock reflects changes" do
      item = OrderItem.find_by(status: "paid")
      previous_stock = item.product.stock
      item.restock
      expect(item.product.stock).must_equal item.quantity + previous_stock
    end
  end
  describe "destock" do
    it "makes no changes when product is out of stock" do
      item = OrderItem.new(quantity: 1)
      item.product = products(:product0)
      result = item.destock
      expect(result).must_equal false
      expect(item.errors.messages[:status]).must_include "#{item.product.name} is now out of stock!"
    end
    it "changes item status to paid" do
      item = OrderItem.find_by(status: "pending")
      result = item.destock
      expect(result).must_equal true
      expect(item.status).must_equal "paid"
    end
    it "item product stock reflects changes" do
      item = OrderItem.find_by(status: "pending")
      previous_stock = item.product.stock
      item.destock
      expect(item.product.stock).must_equal previous_stock - item.quantity
    end
  end
  describe "ship" do 
    it "changes status from paid to shipped" do
      item = OrderItem.find_by(status: "paid")
      result = item.ship
      expect(result).must_equal true
      expect(item.status).must_equal "shipped"
    end
    it "returns false and error when item still pending" do
      item = OrderItem.find_by(status: "pending")
      result = item.ship
      expect(result).must_equal false
      expect(item.errors.messages[:status]).must_include "Pending item can't be shipped"
    end
  end
end
