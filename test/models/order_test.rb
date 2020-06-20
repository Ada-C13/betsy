require "test_helper"

describe Order do
  let(:empty_cart) {
    orders(:empty_cart)
  }
  let(:full_cart) {
    orders(:full_cart)
  }
  let(:paid_order) {
    orders(:paid_order)
  }
  let(:all_orders) {
    [empty_cart, full_cart, paid_order]
  }
  describe "validations" do
    describe "validations are all replying on the status" do
      before do 
        statuses = ["pending", "paid", "shipped", "baloney", nil]
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
      it "paid, shipped are not valid without address, name, etc" do
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
      end
      it "invalid statuses create invalid orders" do
        bad_order = @orders_with_only_status[3] # "baloney"
        expect(bad_order.valid?).must_equal false
        bad_order = @orders_with_only_status[4] # nil
        expect(bad_order.valid?).must_equal false
      end
    end
  end

  describe "relationships" do
    it "order has many order_items" do
      expect(full_cart.order_items.count).must_equal 2
      full_cart.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end
    it "has many products through order_items" do
      expect(full_cart.products.count).must_equal 2
      full_cart.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "custom method: cancel" do 
    it "be able to update a valid status" do
      @order1 = Order.create
      items = OrderItem.all.find_all {|o_i| o_i.status = "paid"}
      @order1.order_items = items
      all_changed = @order1.cancel
      expect(all_changed).must_equal true
      expect(@order1.status).must_equal "cancelled"
    end
    it "given an order of all paid items, it changes all status of items to cancelled" do
      items = OrderItem.all.find_all {|o_i| o_i.status = "paid"}
      order = Order.create
      order.order_items = items
      all_changed = order.cancel
      expect(all_changed).must_equal true
      order.order_items.each do |item|
        expect(item.status).must_equal "cancelled"
      end
    end

    it "can't change the status to cancelled if the current status == shipped" do
      # paid_order contains a shipped and a paid order_item
      shipped_item = paid_order.order_items.find{|o_i| o_i.status == "shipped"}
      all_changed = paid_order.cancel
      expect(all_changed).must_equal false
      expect(paid_order.errors.messages.values.pop).must_include ["#{shipped_item.product.name} is already shipped"]
    end
  end

  describe "custom method: submit_order" do 
    it "be able to update a valid status" do
      # full_cart status == "pending" and has 2 products (product1 x 1 + product4 x 5)
      full_cart.submit_order
      expect(full_cart.status).must_equal "paid"
    end

    it "can't change the status to paid if the current status == paid " do
      result = paid_order.submit_order
      expect(result).must_equal false
    end

    it "all of its order items are now paid status, with products stock updated" do
      items = OrderItem.all.find_all {|item| 
        item.status == "pending" && item.product.stock > item.quantity
      }
      old_stocks = {}
      items.each do |item|
        old_stocks["#{item.product.id}"] = item.product.stock
      end
      order = Order.new(
        name: 'Lak',
        email: 'lak@ada.org',
        address: '244 Thomas str',
        cc_last_four: '2340',
        cc_exp_month: '10',
        cc_exp_year: '2024',
        cc_cvv: '543'
      )
      order.order_items = items
      submit = order.submit_order
      expect(submit).must_equal true
      items.each do |item|
        expect(item.status).must_equal "paid"
      end
      items.each do |item|
        expect(
          item.product.stock
        ).must_equal old_stocks["#{item.product.id}"] - item.quantity
      end
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
      empty_cart.order_items << item
      expect(empty_cart.order_items.length).must_equal 1

      is_empty = empty_cart.clear_cart
      expect(empty_cart.order_items.length).must_equal 0
    end
  end

  describe "custom method: total_price" do 
    it "returns total price for cart with multiple items" do
      items = OrderItem.all.find_all {|item|
        item.order == full_cart
      }
      expected_total = items.sum { |item| 
        item.product.price * item.quantity
      }
      expect(full_cart.total_price).must_equal expected_total
    end
    it "returns total price for complete order with multiple items" do
      items = OrderItem.all.find_all {|item|
        item.order == paid_order
      }
      expected_total = items.sum { |item| 
        item.product.price * item.quantity
      }
      expect(paid_order.total_price).must_equal expected_total
    end
    it "returns 0.00 when cart is empty" do
      expect(empty_cart.total_price).must_equal 0
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
