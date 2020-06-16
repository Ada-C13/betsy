require "test_helper"

describe Order do
  describe "total" do
    it "calculates the order total accurately" do
      order = orders(:pending_order)
      expect(order.total).must_be_close_to (4.4 + 4.4 + 5.4), 0.001
    end
  end

  describe "find_merchants_ids" do
    it "finds merchant ids for a specific order" do
      order = orders(:complete_order)
      order.products.each do |prod|
        prod.merchant = merchants(:merchant_two)
      end
      expect(order.find_merchants_ids.first).must_equal merchants(:merchant_two).id
      expect(order.find_merchants_ids.last).must_equal merchants(:merchant_two).id
      expect(order.find_merchants_ids.count).must_equal 2
    end

    it "returns empty array if there are no products in the order" do
      order = orders(:complete_order)
      order.products = []
      expect(order.find_merchants_ids.count).must_equal 0
      expect(order.find_merchants_ids).must_be_instance_of Array
    end
  end
end
