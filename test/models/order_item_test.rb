require "test_helper"

describe OrderItem do
  describe "subtotal" do
    it "calculates the item subtotal accurately" do
      order_item = order_items(:order_item1)
      expect(order_item.subtotal).must_be_close_to (4.4 + 4.4), 0.001
    end
  end
end
