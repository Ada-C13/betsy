require "test_helper"

describe Order do
  describe "total" do
    it "calculates the order total accurately" do
      order = orders(:pending_order)
      expect(order.total).must_be_close_to (4.4 + 4.4 + 5.4), 0.001
    end
  end

  describe "search" do
    before do
      @order = orders(:pending_order)
    end

    let (:search) {
      {
        id: @order.id,
        email: @order.email
      }
    }

    it "returns an order given a valid id and email" do
      expect(Order.search(search)).must_be_instance_of Order
    end

    it "returns nil if given an invalid id" do
      search[:id] = -1
      expect(Order.search(search)).must_be_nil
    end

    it "returns nil if given an invalid email" do
      search[:email] = nil
      expect(Order.search(search)).must_be_nil
    end
  end
end
