require "test_helper"

describe Merchant do
  describe "custom methods" do 
    describe "total revenue" do 
      it "correctly calculates total revenue for one specific merchant" do 
        merchant = merchants(:merchant_two)
        product_one = products(:crystal)
        product_two = products(:wand)

        order = Order.new
        order.save 

        order_item_one = OrderItem.create(product_id: product_one.id, order_id: order.id, quantity: 2)
        expect(order_item_one.valid?).must_equal true
        order_item_two = OrderItem.create(product_id: product_two.id, order_id: order.id, quantity: 2)
        expect(order_item_two.valid?).must_equal true 

        expect(merchant.total_revenue).must_equal 72
      end

      it "correctly calculates revenue if order has order_items from different merchants" do 
        merchant = merchants(:merchant_two)
        product_one = products(:crystal)
        product_two = products(:wand)
        product_two.merchant_id = merchants(:merchant_one).id
        product_two.save 
        expect(product_two.merchant_id).must_equal merchants(:merchant_one).id 

        order = Order.new
        order.save 

        order_item_one = OrderItem.create(product_id: product_one.id, order_id: order.id, quantity: 2)
        expect(order_item_one.valid?).must_equal true
        order_item_two = OrderItem.create(product_id: product_two.id, order_id: order.id, quantity: 2)
        expect(order_item_two.valid?).must_equal true 

        expect(merchant.total_revenue).must_equal 31
      end
    end
  end
end
