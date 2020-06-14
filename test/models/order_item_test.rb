require "test_helper"

describe OrderItem do
  describe "subtotal" do
    it "calculates the item subtotal accurately" do
      order_item = order_items(:order_item1)
      expect(order_item.subtotal).must_equal 8.80
    end
  end
end
