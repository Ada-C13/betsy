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

    it "order_item belongd to a product" do
      @order_items.each do |order_item|
        expect(order_item.product).must_be_instance_of Product
      end
    end

    it "order_item belongd to a order" do
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
end
