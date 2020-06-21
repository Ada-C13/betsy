require "test_helper"

describe Merchant do
  let(:merchant) {
    Merchant.new(
      username: "Hollerin Harriet",
      email: "Holler@harriet.com",
      uid: 1115,
      provider: "github"
    )
  }

  describe "validations" do
    it "is valid with all fields present and valid" do
      expect(merchant.valid?).must_equal true
    end

    it "is invalid without a username" do
      merchant.username = nil

      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end

    it 'is invalid without a unique email address' do
      invalid_merchant = Merchant.create(username: "new merchant", email: " ")

      expect(invalid_merchant.valid?).must_equal false
      expect(invalid_merchant.errors.messages).must_include :email
    end
  end

  describe "relations" do
    before do
      @merchant = merchants(:bob)
      @orderitem = orderitems(:nature_valley)
      @product = products(:nature_valley)
    end

    it "can have one or many products" do
      @merchant.must_respond_to :products

      @merchant.products.each do |product|
        product.must_be_kind_of Product
      end
      
      expect(@merchant.products.count).must_equal 5
    end

    it "can set the merchant id through product" do
      before_count = Product.count
      bob_products_before = @merchant.products.count

      new_product = Product.new(
        product_name: "Thelma thermos",
        description: "Parking pass for local parks in winter",
        price: 25,
        stock: 15,
        retired: false
      )

      @merchant.products << new_product
      expect(new_product.valid?).must_equal true
      expect(Product.count).must_equal before_count + 1
      expect(@merchant.products.count).must_equal bob_products_before + 1
      expect(@merchant.products.last.merchant_id).must_equal @merchant.id
      expect(new_product.merchant_id).must_equal @merchant.id
    end
  end

# CUSTOM MODEL METHODS:

  describe "build_from_github" do 
    it "creates a new merchant" do 
      auth_hash = {
        provider: "github",
        uid: 1115 ,
        "info" => {
          "email" => "merchant@email.com",
          "username" => "Hollerin Harriet"
        }
      }

      merchant = Merchant.build_from_github(auth_hash)
      merchant.save!

      expect(Merchant.count).must_equal 1

      expect(merchant.provider).must_equal auth_hash[:provider]
      expect(merchant.uid).must_equal auth_hash[:uid]
      expect(merchant.username).must_equal auth_hash["info"]["username"]
      expect(merchant.email).must_equal auth_hash["info"]["email"]
    end
  end

  describe "revenue_by_status" do
    it "returns the correct total revenue for a merchant's products sold in an order of a given status" do
      merchant = merchants(:greta)

      expect(merchant.revenue_by_status("complete")).must_be_kind_of Float
      expect(merchant.revenue_by_status("complete")).must_equal 25
      expect(merchant.revenue_by_status("pending")).must_equal 25
      expect(merchant.revenue_by_status("cancelled")).must_equal 0
    end

    it "returns 0 if there is no revenue associated with merchant orders of a certain status" do
      merchant = merchants(:greta)

      expect(merchant.revenue_by_status("cancelled")).must_equal 0
    end

    it "will return 0 for a non-existing status" do 
      merchant = merchants(:greta)

      expect(merchant.revenue_by_status("n/a")).must_be_kind_of Integer
      expect(merchant.revenue_by_status("n/a")).must_equal 0
    end
  end

  describe "total_revenue" do
    it "correctly calculates the total revenue for a merchant" do
      merchant = merchants(:greta)
      expect(merchant.total_revenue).must_equal 25
    end

    it "does not include revenue from orders that are pending or cancelled" do
      merchant = merchants(:bob)

      paid_total = merchant.revenue_by_status("paid")
      complete_total = merchant.revenue_by_status("complete")
      projected_total = complete_total + paid_total

      # Bob has 5 orders, 2 of which are pending or cancelled
      expect(merchant.all_orders.count).must_equal 5
      expect(merchant.order_status("pending").length).must_equal 1
      expect(merchant.order_status("cancelled").length).must_equal 1
      
      # Bob would have earned $5,002.45 on his pending and cancelled orders
      expect(merchant.revenue_by_status("pending")).must_equal 2.45
      expect(merchant.revenue_by_status("cancelled")).must_equal 5000

      # expect Bob's total to match calculated total for only relevant orders
      expect(merchant.total_revenue).must_equal projected_total
    end

    it "returns 0 if a merchant has not sold any products" do
      merchant = merchants(:no_products_merchant)
   
      expect(merchant.total_revenue).must_equal 0
    end
  end

  describe "all_orders" do
    before do
      @merchant = merchants(:greta)
    end

    it "finds all the orders containing at least one item from a merchant" do
      merchant2 = merchants(:bob)
      merchant3 = merchants(:no_products_merchant)

      # Greta's products (snow_pass) are in 2 separate orders
      # while Bob's products are in 5 orders
      expect(@merchant.all_orders).must_be_kind_of Array
      expect(@merchant.all_orders.length).must_equal 2
      expect(merchant2.all_orders.length).must_equal 5
      expect(merchant3.all_orders.length).must_equal 0
    end

    it "returns an empty array if there are no items from that merchant in any order" do
      merchant = merchants(:no_products_merchant)
      expect(merchant.all_orders.count).must_equal 0
    end
  end
  
  describe "order_status" do
    it "finds all of a merchant's orders of a certain status" do
      @merchant = merchants(:greta)

      expect(@merchant.order_status("complete")).must_be_kind_of Array
      expect(@merchant.order_status("complete").length).must_equal 1
      expect(@merchant.order_status("pending").length).must_equal 1
    end

    it "returns an empty collection if there are no merchant orders of a certain status" do
      # greta does not have any cancelled orders
      @merchant = merchants(:greta)

      expect(merchant.order_status("cancelled")).must_be_kind_of Array
      expect(merchant.order_status("cancelled").length).must_equal 0
    end
  end
end