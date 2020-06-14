require "test_helper"

describe Order do
  describe "total" do
    it "calculates the order total accurately" do
      order = orders(:pending_order)
      expect(order.total).must_be_close_to (4.4 + 4.4 + 5.4), 0.001
    end
  end
end
