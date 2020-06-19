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

  describe "filter_products function" do
    before do
      @categories_ids = [categories(:flower).id, categories(:herb).id]
      @merchant_ids = [merchants(:annie).id, merchants(:melba).id, merchants(:katherine).id]
    end

    it 'can filter products with only category input' do
      @merchant_ids = []
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      expect( products.count ).must_equal 3
    end

    it 'can filter products with only merchant input' do
      @categories_ids = []
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      expect( products.count ).must_equal 4
    end

    it 'can filter products with category and merchant input' do
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      expect( products.count ).must_equal 4
    end

    it 'will return an empty array with no valid ids' do
      results = Product.filter_products(["hi", 'cool'], ['ada', 'betsy'])
      products = results[:products]
      expect( products ).must_equal []
    end

    it 'will return a list of category and filter names' do
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      filter_names = results[:filters]
      expect( products ).must_be_kind_of Array
      expect( filter_names ).must_be_kind_of Array
      expect( filter_names ).must_include "flower"
    end

    it 'will return all products that are uniq' do
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      expect( products ).must_equal products.uniq
    end

    it 'will only return products that are currently active' do
      results = Product.filter_products(@categories_ids, @merchant_ids)
      products = results[:products]
      expect( products ).wont_include "cilantro"
    end
  end

  describe "active_products function" do
    it 'can get all products that are currently active' do
      products = Product.active_products
      expect( products ).wont_include products(:cilantro)
      expect( products ).must_include products(:mint)
      expect( products.count ).must_equal 4
    end

    it 'will return all products that are uniq' do
      products = Product.active_products
      expect( products ).must_equal products.uniq
    end
  end
end
