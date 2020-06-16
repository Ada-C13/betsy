require "test_helper"

describe Product do
  describe "validations" do
    before do 
      @product = Product.new(
        title: "flower",
        price: 25,
        photo_url: "some string",
        description: "magic flower",
        stock: 5,
        merchant_id: 4,
        active: true
      )
    end

    it "is valid when all fields are present" do 
      result = @product.valid?

      expect(result).must_equal true
    end

    it "is invalid without a title" do 
      @product.title = nil 

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid if the same title already exists" do 
      exiting_product = products(:plant)

      @product.title = "plant"
      result = @product.valid?

      expect(result).must_equal false
    end

    it "is inavlid without a price" do 
      @product.price = nil 

      result = @product.valid? 

      expect(result).must_equal false
    end

    it "is invalid if price is equal to 0" do 
      @product.price = 0

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid if price is less than 0" do 
      @product.price = -1

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid if price is not a number" do 
      @product.price = "a"

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid without a stock value" do 
      @product.stock = nil

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid if the stock is not a number" do 
      @product.stock = "hello"

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is invalid if stock is less than 0" do 
      @product.stock = -1

      result = @product.valid?

      expect(result).must_equal false
    end

    it "is valid if stock equals to 0" do 
      @product.stock = 0

      result = @product.valid?

      expect(result).must_equal true
    end
  end

  describe "relations" do 
    before do 
      @merchant = Merchant.create!(
        id: 5,
        username: "peter",
        uid: 7878743,
        email: "peter@gmail.com ",
        provider: "github"
      )
      @product = Product.new(
        title: "tinkerbell",
        price: 40,
        photo_url: "photo of tinkerbell",
        description: "magic tinkerbell",
        stock: 5, 
        active: true
      )
    end

    it "can set the merchant through 'merchant'" do 
      @product.merchant = @merchant

      expect(@product.merchant_id).must_equal @merchant.id
    end

    it "can set the merchant through 'merchant_id'" do 
      @product.merchant_id = @merchant.id 

      expect(@product.merchant).must_equal @merchant
    end

  end
end
