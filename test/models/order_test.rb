require "test_helper"

describe Order do
  before do
    @order = Order.new(
      name: "jojo",
      email: "jojo@bizarreadventure.org",
      cc_number: 1234567890123456,
      cc_exp: Date.today + 365,
      cvv: 123,
      mailing_address: "123 sesame street",
      zipcode: 12345
  
    )
    end
  describe "relations" do
    it "has many order items" do
      expect(@order).must_respond_to :order_items
    end
    it "has many products" do
      expect(@order).must_respond_to :products
  end
end

  describe "validations" do
    it 'is valid when all fields are present' do
      expect(@order.valid?).must_equal true
    end

  it "is invalid without a name" do
    @order.update(name: nil)
    expect(@order.valid?).must_equal false
    expect(@order.errors.messages).must_include :name
  end

  it "is invalid without an email" do
    @order.update(email: nil)
    expect(@order.valid?).must_equal false
    expect(@order.errors.messages).must_include :email
  end
  it "is invalid without a credit card number" do
    @order.update(cc_number: nil)
    expect(@order.valid?).must_equal false
  end

  it "is invalid without a cc expiration" do
    @order.update(cc_exp: nil)
    expect(@order.valid?).must_equal false
  end
  it "is invalid without an address" do
    @order.update(mailing_address: nil)
    expect(@order.valid?).must_equal false
  end
  it "is invalid without a zipcode" do
    @order.update(zipcode: nil)
    expect(@order.valid?).must_equal false
  end
end

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
