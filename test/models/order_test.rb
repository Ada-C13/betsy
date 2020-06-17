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
        bad_order = @orders_with_only_status[4] # "baloney"
        expect(bad_order.valid?).must_equal false
        bad_order = @orders_with_only_status[5] # nil
        expect(bad_order.valid?).must_equal false
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

  describe "private custom method: change_status" do
    before do
      @order1 = orders(:paid_order) # status == "paid" and has 2 products (product1 x 3 + product3 x 5)
      @order2 = orders(:full_cart) # status == "pending" and has 2 products (product1 x 1 + product4 x 5)
    end

    it "be able to update a valid status" do
      expect(@order1.change_status("shipped")).must_equal true
      expect(@order2.change_status("paid")).must_equal true
    end

    it "raise error when trying to update a invalid status" do
      expect(@order1.change_status("baloney")).must_equal false
    end

    it "raise error when try to update the status to nil" do
      expect(@order2.change_status(nil)).must_equal false
    end
  end

  describe "custom method: cancel" do 
    it "be able to update a valid status" do
      @order1 = orders(:paid_order) # status == "paid" and has 2 products (product1 x 3 + product3 x 5)
      result = @order1.cancel
      expect(result).must_equal true
      expect(@order1.status).must_equal "cancelled"
    end

    it "can't change the status to cancelled if the current status == shipped" do
      @order1 = orders(:shipped_order)
      result = @order1.cancel
      expect(result).must_equal false
      expect(@order1.errors).must_include :status
      expect(@order1.errors.messages[:status]).must_include "can't cancel shipped order"
    end
  end

  describe "custom method: submit_order" do 
    it "be able to update a valid status" do
      @order1 = orders(:full_cart) # status == "pending" and has 2 products (product1 x 1 + product4 x 5)
      @order1.submit_order
      expect(@order1.status).must_equal "paid"
    end

    it "can't change the status to paid if the current status == paid " do
      @order1 = orders(:paid_order)
      result = @order1.submit_order
      expect(result).must_equal false
    end
  end

  describe "custom method: clear_cart" do 
    let(:new_product) { 
      Product.new(
        name: "XXXX", 
        price: 20.00,
        stock: 20,
        description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
        photo: "https://i.imgur.com/WSHmeuf.jpg",
        merchant: nil
      )
    }

    it "removes order_items from cart" do
      new_product.merchant = merchants(:merchantaaa)
      item = OrderItem.new(quantity: 1)
      item.product = new_product
      @order = orders(:empty_cart)
      @order.order_items << item
      expect(@order.order_items.length).must_equal 1

      is_empty = @order.clear_cart
      expect(@order.order_items.length).must_equal 0
    end
  end

  describe "custom method: total_price" do 
    it "returns total price for cart with multiple items" do
      @order1 = orders(:full_cart)
      expect(@order1.total_price).must_equal 612
    end
    it "returns total price for complete order with multiple items" do
      @order1 = orders(:paid_order)
      expect(@order1.total_price).must_equal 536
    end
    it "returns 0.00 when cart is empty" do
      @order1 = orders(:empty_cart)
      expect(@order1.total_price).must_equal 0
    end
  end

  describe "custom method: find_order_item(product)" do
    let(:new_product) { 
      Product.new(
        name: "XXXX", 
        price: 20.00,
        stock: 20,
        description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
        photo: "https://i.imgur.com/WSHmeuf.jpg",
        merchant: nil
      )
    }
    it "return the order_item if it is already in the cart/order" do
      @order = orders(:full_cart)
      @product = products(:product1)
      @order_item = order_items(:order_item1)
      expect(@order.find_order_item(@product)).must_equal @order_item
    end

    it "return nil if the order_item is not currently in the cart/order" do
      new_product.merchant = merchants(:merchantaaa)
      @order = orders(:full_cart) # has product1 and product4 in the fall_cart
      expect(@order.find_order_item(new_product)).must_equal nil
    end
  end
end
