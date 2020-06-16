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
end
