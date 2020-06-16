require "test_helper"

describe Product do
  before do
    @merchant = merchants(:merchantaaa)
    @new_product = Product.new(
      name: "XXXX", 
      price: 20.00,
      stock: 20,
      description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
      photo: "https://i.imgur.com/WSHmeuf.jpg",
      merchant: merchants(:merchantaaa)
    )
   
  end

  it "can be instantiated" do
    # Assert
    expect(@new_product.valid?).must_equal true

  end


  it "will have the required fields" do
    # Arrange
    @new_product.save
    product = Product.first
    [:name, :price, :stock, :description, :photo, :merchant_id].each do |field|
      # Assert
      expect(product).must_respond_to field
    end
  end

  it "active must be true when product created (default)" do
    # Assert
    expect(@new_product.active).must_equal true
  end

  describe "relationships" do
    it "the product belongs to merchant" do
      # Arrange
      @new_product.save
      
      # Assert
      expect(@merchant.products.count).must_equal 3
      @merchant.products.each do |product|
        expect(product).must_be_instance_of Product
      end 
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      @new_product.name = nil

      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :name
      expect(@new_product.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a price" do
      # Arrange
      @new_product.price = nil

      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :price
      expect(@new_product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have a postive price" do
      # Arrange
      @new_product.price = -20.00
      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :price
      expect(@new_product.errors.messages[:price]).must_equal ["must be greater than 0"]

    end

    it "must have a stock" do
      # Arrange
      @new_product.stock = nil

      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :stock
      expect(@new_product.errors.messages[:stock]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have a postive stock" do
      # Arrange
      @new_product.stock = -100
      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :stock
      expect(@new_product.errors.messages[:stock]).must_equal ["must be greater than or equal to 0"]
    end

    it "must have an description" do
      # Arrange
      @new_product.description = nil
      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :description
      expect(@new_product.errors.messages[:description]).must_equal ["can't be blank"]
    end

    it "must have an photo" do
      # Arrange
      @new_product.photo = nil
      # Assert
      expect(@new_product.valid?).must_equal false
      expect(@new_product.errors.messages).must_include :photo
      expect(@new_product.errors.messages[:photo]).must_equal ["can't be blank"]
    end
  end
end
