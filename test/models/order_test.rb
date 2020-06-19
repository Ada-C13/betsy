require "test_helper"

describe Order do
  describe "order_purchase" do
    it "reduces the number of inventory for each product" do
      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_4)

      product1_count = order_item1.product.inventory
      product2_count = order_item2.product.inventory

      order.order_purchase

      expect(order_item1.product.reload.inventory).must_equal product1_count - order_item1.quantity
      expect(order_item1.product.reload.inventory).must_equal product2_count - order_item2.quantity
    end

    it "changes the order state from pending to paid" do
      orders(:order_1).order_purchase

      expect(orders(:order_1).status).must_equal "paid"
    end
  end

  describe "order_cost" do
    it "should return correct order cost" do
      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_4)

      sum = (order_item1.product.price * order_item1.quantity) + (order_item2.product.price * order_item2.quantity)
      cost = order.order_cost

      expect(cost).must_equal sum
    end
  end

  describe "relationships" do
    it "can have many order_items" do
      product = products(:product_1)
      order = orders(:order_1)

      count = order.order_items.count

      order_item1 = OrderItem.create(product: product, quantity: 1, order: order)
      order_item2 = OrderItem.create(product: product, quantity: 1, order: order)
      expect(order.reload.order_items.count).must_equal count + 2
    end
  end

  describe "cancel_order_inventory" do
    it "should return correct status and decrease the inventoty of the product" do
      order = orders(:paid_order)
      order_item5 = order_items(:order_item_5)
      product_1 = products(:product_1)
      order_item5.product_id

      order.cancel_order_inventory

      expect(order.status).must_equal "cancelled"
    end
  end

  describe "Validations" do

    it "requires a emal" do
      order = orders(:paid_order)
      order.email = nil
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :email
    end

    it "requires a name" do
      order = orders(:paid_order)
      order.name = nil
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :name
    end

    it "requires a credit_card" do
      order = orders(:paid_order)
      order.credit_card = nil
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :credit_card
    end

    it "requires a address" do
      order = orders(:paid_order)
      order.address = nil
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :address
    end
  end
end
