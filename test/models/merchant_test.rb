require "test_helper"

describe Merchant do
  describe "custom methods" do 
    before do 
      @merchant = merchants(:merchant_two)
      @product_one = products(:crystal)
      @product_two = products(:wand)
    end

    describe "total revenue" do 
      it "correctly calculates total revenue for one specific merchant" do 
        order = orders(:complete_order)
        order2 = orders(:paid_order)

        expect(@merchant.total_revenue).must_equal 82
      end

      it "correctly calculates revenue if order has order_items from different merchants" do 
        @product_two.merchant_id = merchants(:merchant_one).id
        @product_two.save 
        expect(@product_two.merchant_id).must_equal merchants(:merchant_one).id 

        order = orders(:complete_order)
        order2 = orders(:paid_order)

        expect(@merchant.total_revenue).must_equal 41
      end
    end

    describe "revenue_for" do 
      it "calculates revenue separately for paid orders" do 
        order = orders(:complete_order)
        order2 = orders(:paid_order)

        expect(@merchant.revenue_for(order2.status)).must_equal 10
      end

      it "calculates revenue separately for complete orders" do 
        order = orders(:complete_order)
        order2 = orders(:paid_order)

        expect(@merchant.revenue_for(order.status)).must_equal 72
      end

      it "calculates revenue separately for pending orders" do 
        @merchant = merchants(:merchant_three)
        order = orders(:order_pending)

        expect(@merchant.revenue_for(order.status)).must_equal 7
      end

      it "calculates revenue separately for cancelled orders" do 
        order = orders(:cancelled_order)

        expect(@merchant.revenue_for(order.status)).must_equal 16
      end
    end

    describe "number_of_orders_for" do
      it "will display number of orders by status" do 
        pending_orders_count = @merchant.number_of_orders_for("pending")
        expect(pending_orders_count).must_equal 0

        complete_orders_count = @merchant.number_of_orders_for("complete")
        expect(complete_orders_count).must_equal 1

        paid_orders_count = @merchant.number_of_orders_for("paid")
        expect(paid_orders_count).must_equal 1

        cancelled_orders_count = @merchant.number_of_orders_for("cancelled")
        expect(cancelled_orders_count).must_equal 1

      end
    end
  end
end
