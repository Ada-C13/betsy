require "test_helper"

describe Product do

  let (:product_1) {
    products(:product_1)
  }

  let (:product_hash) {
    {
      product: {
        name: "Monstera",
        price:  39.99,
        description:  "Big green plant!",
        inventory:  3,
        merchant_id:  merchant_1.id
      }
    }
  }

  describe "validations" do

    it "is valid when all fields are present" do
      # Act
      result = product_1.valid?

      # Assert
      expect(result).must_equal true
    end

    it "is invalid without a name" do
      # Arrange
      product_1.name = nil
    
      # Act
      result = product_1.valid?
    
      # Assert
      expect(result).must_equal false
      # expect(@product_1.errors.messages).must_include :name
    end

    it "is invalid without a price" do
      # Arrange
      product_1.price = nil
    
      # Act
      result = product_1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(product_1.errors.messages).must_include :price
    end

    it "is invalid without a price greater than 0" do
      # Arrange
      product_1.price = 0
    
      # Act
      result = product_1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(product_1.errors.messages).must_include :price
    end

    it "is invalid without an inventory" do
      # Arrange
      product_1.inventory = nil
    
      # Act
      result = product_1.valid?
    
      # Assert
      expect(result).must_equal false
      expect(product_1.errors.messages).must_include :inventory
    end
  end
end
