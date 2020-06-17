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

    describe "existing_order_items_by_merchant" do
      it "returns all order_items for 1 merchant" do
        order_items = @merchant.existing_order_items_by_merchant
        expect(order_items.count).must_equal 4
      end

      it "returns empty array if order_items are equal to zero" do
        @merchant.products.destroy_all
        expect(@merchant.existing_order_items_by_merchant.count).must_equal 0
        expect(@merchant.existing_order_items_by_merchant).must_be_instance_of Array
      end
    end

    describe "find_orders_by_status" do
      it "returns only orders with a specific status" do
        result = @merchant.find_orders_by_status("complete")
        expect(result.size).must_equal 2
        result.each do |order_item|
          expect(order_item.order.status).must_equal "complete"
        end
      end

      it "return an empty array if no orders with such status found" do
        result = @merchant.find_orders_by_status("pending")
        expect(result.size).must_equal 0
        expect(result).must_be_instance_of Array
      end

      it "return all existing orders for a merchant if status is not given" do
        existing_orders = @merchant.existing_order_items_by_merchant
        result = @merchant.find_orders_by_status("")
        expect(result.size).must_equal existing_orders.count
      end
    end
  end

  describe "relations" do
    it "has a list of products" do
      merchant = merchants(:merchant1)
      expect(merchant).must_respond_to :products
      merchant.products.each do |product|
        expect(product).must_be_kind_of Product
      end
    end
  end
  
  describe "validations" do
    it "requires a uid" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :uid
    end
    
    it "requires a unique uid" do
      uid = "test uid"
      merchant = Merchant.new(username: "username", uid: uid, email: "email" )
      
      merchant.save!
      
      merchant2 = Merchant.new(username: "otherusername", uid: uid, email: "otheremail")
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :uid
    end
    
    it "requires a username" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end
    
    it "requires a unique username" do
      username = "test username"
      merchant = Merchant.new(username: username, uid: "87654", email: "email")
      
      # This must go through, so we use create!
      merchant.save!
      
      merchant2 = Merchant.new(username: username, uid: "67890", email: "otheremail")
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :username
    end
    it "requires an email" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end
    
    it "requires a unique email" do
      email = "testemail@email.com"
      merchant = Merchant.new(username: "username", uid: "76543", email: email)
      
      # This must go through, so we use create!
      merchant.save!
      
      merchant2 = Merchant.new(username: "otherusername", uid: "98754", email: email)
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :email
    end
  end
end
