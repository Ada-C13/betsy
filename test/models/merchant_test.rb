require "test_helper"
require 'pry'

describe Merchant do
  
  describe "merchant product relations" do
    
    it "can have many products" do
      expect(merchants(:merchant1)).must_respond_to :products
      expect(merchants(:merchant1).products.length).must_equal 3
  
      merchants(:merchant1).products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
    
    it "can have zero products" do
      merchant = merchants(:merchant0)
      expect(merchant.products.length).must_equal 0
    end
  end

  describe "validations" do
    let (:merchant3) {
      Merchant.new(
        username: "Fa the Merch",
        email: "fa@merch.com",
        uid: 3,
        provider: "github",
      )
    }

    it "is valid for a merchant with all required fields" do
      expect(merchant3.valid?).must_equal true
    end 

    it "has the required fields" do
      merchant3.save
      new_merchant = Merchant.last
    
      [:username, :email, :uid, :provider].each do |field|
        expect(new_merchant).must_respond_to field
      end
    end

    it "is invalid without a username" do
      merchant3.username = nil
    
      expect(merchant3.valid?).must_equal false
      expect(merchant3.errors.messages).must_include :username
    end

    it "cannot create a new merchant with the same username in the same provider" do
      merchant3.save
      merchant4 = Merchant.new(
        username: "Fa the Merch",
        email: "fa@blah.com",
        uid: 4,
        provider: "github",
      )
      expect(merchant4.valid?).must_equal false
      expect(merchant4.errors.messages).must_include :username
    end

    it "is invalid without a email" do
      merchant3.email = nil
    
      expect(merchant3.valid?).must_equal false
      expect(merchant3.errors.messages).must_include :email
    end

    it "cannot creat a new merchant with the same email in the same provider" do
      merchant3.save
      merchant4 = Merchant.new(
        username: "blah",
        email: "fa@merch.com",
        uid: 4,
        provider: "github",
      )
      expect(merchant4.valid?).must_equal false
      expect(merchant4.errors.messages).must_include :email
    end

    it "is invalid without a uid" do
      merchant3.uid = nil
    
      expect(merchant3.valid?).must_equal false
      expect(merchant3.errors.messages).must_include :uid
    end

    it "cannot creat a new merchant with the same uid in the same provider" do
      merchant3.save
      merchant4 = Merchant.new(
        username: "blah",
        email: "fa@blah.com",
        uid: 3,
        provider: "github",
      )
      expect(merchant4.valid?).must_equal false
      expect(merchant4.errors.messages).must_include :uid
    end

    it "is invalid without a provider" do
      merchant3.provider = nil
    
      expect(merchant3.valid?).must_equal false
      expect(merchant3.errors.messages).must_include :provider
    end

  end

  describe "merchant model methods" do
    before do 
      # Arrange - Act
      @test_merchant0 = merchants(:merchant0)
      @test_merchant1 = merchants(:merchant1)
      @test_merchant2 = merchants(:merchant2)
    end 

    describe "create_merchant_from_github" do 
      it "creates a valid merchant with a valid auth hash" do 
        mock_auth_hash = {"uid" => 1, "provider" => 'github', "info" => {"name" => "Test", "email" => "test@test.com"}}
        
        merchant = Merchant.create_merchant_from_github(mock_auth_hash)
        merchant.save
        expect(merchant).must_be_kind_of Merchant
        expect(merchant.nil?).must_equal false
      end 

      it "creates a valid merchant even if auth hash doesn't provide access to name" do 
        mock_auth_hash = {"uid" => 1, "provider" => 'github', "info" => {"email" => "test@test.com"}}
        
        merchant = Merchant.create_merchant_from_github(mock_auth_hash)
        merchant.save
        expect(merchant).must_be_kind_of Merchant
        expect(merchant.nil?).must_equal false
      end 
    end 
  
    describe "get_all_orders" do 
      before do 
        @merchant0_orders = @test_merchant0.get_all_orders
        @merchant1_orders = @test_merchant1.get_all_orders
        @merchant2_orders = @test_merchant2.get_all_orders
      end

      it "returns an array of all orders that include at least one of the merchant's product" do 
        expect(@merchant1_orders.length).must_equal 2
        expect(@merchant2_orders.length).must_equal 1
      end 

      it "returns an array that does not contain duplicate orders" do 
        expect(@merchant1_orders.uniq).must_equal @merchant1_orders
      end 

      it "returns an array that does not include an order that does not include at least one of it's products" do
        merchants_of_products = []

        # note: merchant 2 only has one order associated with it
        @merchant2_orders.first.order_items.each do |order_item|
          merchants_of_products << order_item.product.merchant_id
        end 

        expect(merchants_of_products).must_include @test_merchant2.id 
      end

      it "returns an empty array when a merchant has 0 products" do 
        expect(@merchant0_orders.length).must_equal 0
      end 
    end 
  
    describe "get_orders_by_status" do 
      before do 
        @merchant0_orders_paid = @test_merchant0.get_orders_by_status("paid")
        @merchant0_orders_complete = @test_merchant0.get_orders_by_status("complete")

        @merchant1_orders_paid = @test_merchant1.get_orders_by_status("paid")
        @merchant1_orders_complete = @test_merchant1.get_orders_by_status("complete")
      end

      it "returns an array of orders only with the specified status" do 
        @merchant1_orders_paid.each do |order| 
          expect(order.status).must_equal "paid"
        end 
        expect(@merchant1_orders_paid.length).must_equal 1

        @merchant1_orders_complete.each do |order| 
          expect(order.status).must_equal "complete"
        end 
        expect(@merchant1_orders_complete.length).must_equal 1
      end 

      it "returns an empty array when a merchant has 0 products with specified status" do 
        expect(@merchant0_orders_complete.length).must_equal 0
        expect(@merchant0_orders_paid.length).must_equal 0
      end 
    end 
  
    describe "find_my_order_items" do 
      before do 
        @merchant0_order = @test_merchant1.get_all_orders.first 
        @merchant0_order_items = @test_merchant0.find_my_order_items(@merchant0_order)

        @merchant1_order = @test_merchant1.get_all_orders.first 
        @merchant1_order_items = @test_merchant1.find_my_order_items(@merchant1_order)

        @merchant2_order = @test_merchant2.get_all_orders.first 
        @merchant2_order_items = @test_merchant2.find_my_order_items(@merchant2_order)
      end

      it "returns an array of order items from an order that is associated with merchant" do
        expect(@merchant1_order_items.length).must_equal 2
        expect(@merchant2_order_items.length).must_equal 1
      end 

      it "does not return any order items that are not associated with merchant" do 
        expect(@merchant1_order_items.first.product.merchant_id).must_equal @test_merchant1.id
        expect(@merchant1_order_items.last.product.merchant_id).must_equal @test_merchant1.id
        expect(@merchant2_order_items.first.product.merchant_id).must_equal @test_merchant2.id
      end 

      it "returns an empty array if there are none of the merchant products in the order" do 
        expect(@merchant0_order_items.length).must_equal 0 
      end 

    end 
  
    describe "earnings_per_order" do 
      before do 
        @merchant0_order = @test_merchant0.get_all_orders.first 
        @merchant0_order_earnings = @test_merchant0.earnings_per_order(@merchant0_order)

        @merchant1_order = @test_merchant1.get_all_orders.last
        @merchant1_order_earnings = @test_merchant1.earnings_per_order(@merchant1_order)
      end

      it "returns the earnings a merchant made on a given order" do 
        # total = (product 1 price * qty) + (product 2 price * qty)
        # 35.95 = (2.99 * 2) + (9.99 * 3)
        expect(@merchant1_order_earnings).must_equal 35.95
      end 

      it "returns 0.00 if there are no merchant products in the order" do 
        expect(@merchant0_order_earnings).must_equal 0.00
      end 
    end 
  
    describe "total_revenue" do 
      before do 
        @merchant0_orders = @test_merchant0.get_all_orders
        @merchant0_total_revenue = @test_merchant0.total_revenue(@merchant0_order)

        @merchant1_orders = @test_merchant1.get_all_orders
        @merchant1_total_revenue = @test_merchant1.total_revenue(@merchant1_orders)
      end 

      it "returns total revenue of a merchant from a collection of orders" do 
        # total = (product 1 price * qty) + (product 2 price * qty) + (product 2 price * qty)
        # 47.90 = (2.99 * 4) + (9.99 * 3) + (1.99 * 3)
        expect(@merchant1_total_revenue).must_equal 47.90
      end 

      it "returns 0.00 if there are no orders associated with merchant" do 
        expect(@merchant0_total_revenue).must_equal 0.00
      end 
    end 
  end
end
