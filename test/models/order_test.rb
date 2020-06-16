require "test_helper"

describe Order do
  describe "validations" do
    describe "validations are all replying on the status" do
      before do 
        statuses = ["pending", "paid", "shipped", "cancelled", "baloney", nil]
        @required_fields = [:name, :email, :address, :cc_last_four, :cc_exp_month, :cc_exp_year, :cc_cvv]
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
      it "paid, shipped, and cancelled are not valid without address, name, etc" do
        order_paid = @orders_with_only_status[1]
        expect(order_paid.valid?).must_equal false
        @required_fields.each do |field|
          expect(order_paid.errors).must_include field
        end

        order_shipped = @orders_with_only_status[2]
        expect(order_shipped.valid?).must_equal false
        @required_fields.each do |field|
          expect(order_shipped.errors).must_include field
        end

        order_cancelled = @orders_with_only_status[3]
        expect(order_cancelled.valid?).must_equal false
        @required_fields.each do |field|
          expect(order_cancelled.errors).must_include field
        end
      end
      it "invalid statuses create invalid orders" do
        order_paid = @orders_with_only_status[4]
        expect(order_paid.valid?).must_equal false
      end
    end
  end

  describe "relationships" do
    before do
      @order = orders(:full_cart) 
    end

    it "order has many order_items" do
      expect(@order.order_items.count).must_equal 2
      @order.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end
    it "has many products through order_items" do
      expect(@order.products.count).must_equal 2
      @order.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "private custom mathod, change_status, is called by the public method: cancel and submit_order" do
    before do
      @order1 = orders(:paid_order) # status == "paid" and has 2 products (product1 x 3 + product3 x 5)
      @order2 = orders(:full_cart) # status == "pending" and has 2 products (product1 x 1 + product4 x 5)
    end

    it "be able to update a valid status" do
      @order1.cancel
      expect(@order1.status).must_equal "cancelled"
      @order2.submit_order
      expect(@order2.status).must_equal "paid"
    end

    # it "raise error when trying to update a invalid status" do
    #   expect{@order1.change_status("baloney")}.must_raise ArgumentError
    #   expect{@order2.change_status("baloney")}.must_raise ArgumentError
    # end

    # it "raise error when try to update the status to nil" do

    # end
  end

  # describe "#clear_cart" do 
  #   it "removes order_items from cart" do
  #   end
  #   it "deletes existing order items" do
  #   end
  # end
  # describe "#total_price" do 
  #   it "returns total price for cart with multiple items" do
  #   end
  #   it "returns total price for complete order with multiple items" do
  #   end
  #   it "returns 0.00 when cart is empty" do
  #   end
  # end
  # describe "#cancel" do 
  # end
end
