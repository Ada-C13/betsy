require "test_helper"

describe OrderItem do
  describe "custom methods" do
    before do
      @item = order_items(:order_item_1)
      @product = products(:product_1)
      @order = orders(:order_1)
    end
    it "can get a list of order items by order" do
      orders = OrderItem.by_order_id(@order.id)
      assert(orders.length > 0)
    end


    it "can set the subtotal for an order item" do
      total = @item.total_per_item
      expect(total).must_be_close_to 2182.7
      assert(@item.total_per_item != nil)
    end
  end
end
