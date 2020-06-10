require "test_helper"

describe Product do
  before do
    @product = products(:tulip)
    @merchant_id = @product.merchant_id
  end

  describe "validations" do

    before do
    @product.merchant_id = merchants(:melba).id
    end

    it "is valid when name and price are present" do
      expect(@product.valid?).must_equal true
    end

    it "is invalid when name is missing" do
    @product.name = nil
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages).must_include :name
    end

    it "is invalid when price is missing" do
    @product.price = nil 
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages).must_include :price
    end

    it "is invalid when merchant has same product already" do
      repeated_product = Product.new(
        name: @product.name,
        description: "doubling up on the tulips",
        photo: "www.google.com/tulips",
        stock: 6,
        active: true,
        price: 12.50,
        merchant_id: @merchant_id
      )
      expect(repeated_product.valid?).must_equal false
      expect(repeated_product.errors.messages).must_include :name
    end

    it "is valid when product name is non-unique but merchant differs" do
      new_merchant = Merchant.create!(
        username: "plantwitch",
        email: "plantcovenhq@plantwitch.com",
      )
      same_name_product = Product.create!(
        name: @product.name,
        description: "doubling up on the tulips",
        photo: "www.google.com/tulips",
        stock: 6,
        active: true,
        price: 12.50,
        merchant_id: Merchant.last.id,
      )
      expect(same_name_product.name).must_equal @product.name
      expect(same_name_product.merchant_id).wont_equal @product.merchant_id
      expect(same_name_product.valid?).must_equal true
    end

  end

  describe "relationships" do
    before do
      @product = products(:cilantro)
    end

    it "belongs to/responds to Merchant" do
      expect(@product.respond_to?(:merchant_id)).must_equal true
    end

    it "has/responds to categories" do
      expect(@product.respond_to?(:categories)).must_equal true
    end

    it "has/responds to reviews" do
      expect(@product.respond_to?(:reviews)).must_equal true
    end

  end
end
