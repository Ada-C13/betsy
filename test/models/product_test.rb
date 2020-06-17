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
    @existing_product = products(:product1)
    @before_stock = @existing_product.stock
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
      expect(@new_product.merchant).must_equal @merchant
    end
    it "has order_items" do
      order_items = OrderItem.all.find_all { |item|
        item.product == @existing_product
      }
      @existing_product.order_items.each do |item|
      expect(order_items).must_include item
      order_items.delete(item)
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

  describe "restock" do
    it "adds expected amount to stock" do
      @existing_product.restock(5)
      expect(@existing_product.stock).must_equal @before_stock + 5
    end
  end
  describe "destock" do
    it "subtracts expected amount to stock" do
      @existing_product.destock(5)
      expect(@existing_product.stock).must_equal @before_stock - 5
    end
  end
  describe "enough_stock?" do
    it "responds false, with right errors to 0 stock" do
      zero_stock_product = products(:product0)
      result = zero_stock_product.enough_stock?(1)
      expect(result).must_equal false
      expect(zero_stock_product.errors.messages[:stock].pop).must_include "out of stock."
    end
    it "responds false, with errors to insufficient stock" do
      little_stock_product = products(:product4)
      result = little_stock_product.enough_stock?(20)
      expect(result).must_equal false
      expect(
        little_stock_product.errors.messages[:stock]
      ).must_include "There are #{little_stock_product.stock} #{little_stock_product.name} in stock, select another quanity."
    end
    it "responds true when enough stock" do
      result = @existing_product.enough_stock?(1)
      expect(result).must_equal true
    end
  end

end
