require "test_helper"

describe Order do
  describe "total" do
    it "calculates the order total accurately" do
      order = orders(:pending_order)
      expect(order.total).must_equal 14.20
    end
  end
end
