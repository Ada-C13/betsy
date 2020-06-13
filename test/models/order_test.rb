require "test_helper"

describe Order do
  describe "validations" do
    describe "status" do
      before do 
        statuses = ["pending", "paid", "shipped", "baloney", nil]
        @orders_with_only_status = []
        statuses.each do |status|
          order = Order.new
          order.status = status
          @orders_with_only_status << order
        end
      end
      it "pending status with no other fields is valid" do
        order = @orders_with_only_status[0]
        expect(order.valid?).must_equal true
      end
      it "paid and shipped are not valid without address, name, etc" do
        order_paid = @orders_with_only_status[1]
        expect(order_paid.valid?).must_equal false
        order_shipped = @orders_with_only_status[2]
        expect(order_shipped.valid?).must_equal false
      end
      it "invalid statuses ccreate invalid orders" do
        expect(@orders_with_only_status[3].valid?).must_equal false
        expect(@orders_with_only_status[4].valid?).must_equal false
      end
      it "invalid statuses raise error message" do
      end
    end
  end
  describe "relationships" do
    describe "has many order_items" do
    end
    describe "has many products through order_items" do
    end
  end


  describe "#submit_order" do 
  end 
  describe "#clear_cart" do 
  end
  describe "#total_price" do 
  end
  describe "#update_status" do 
  end
end
