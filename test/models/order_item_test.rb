require "test_helper"

describe OrderItem do

  let (:order) { orders(:order_pending) }
  let (:merchant) { merchants(:suely) }
  let (:product) { products(:tulip) }

  before do
    order.save!
    merchant.save!

    product.merchant_id = merchant.id
    product.price = 100
    product.save!

    @item = OrderItem.new(
      order_id: order.id,
      product_id: product.id,
      quantity: 2
    )
    @item.save!
  end
  
  describe 'relationships' do
    it 'must belong to a Product' do
      # Arrange & Act
      # in the before block
      # Assert
      expect(@item).must_respond_to :product
      expect(@item.product).must_be_kind_of Product
    end

    it 'must belong to an Order' do
      # Arrange & Act
      # in the before block
      # Assert
      expect(@item).must_respond_to :order
      expect(@item.order).must_be_kind_of Order
    end
  end # describe 'relationships'

  describe 'validations' do
    it 'is valid if quantity is greater than 0' do
      # Arrange
      # in the before block
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal true
    end

    it 'is not valid if quantity is less than or equal to 0' do
      # Arrange
      @item.quantity = 0
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "must be greater than 0"
    end

    it 'is not valid if quantity is not present' do
      # Arrange
      @item.quantity = nil
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "can't be blank"
    end

    it 'is not valid if quantity is not a number' do
      # Arrange
      @item.quantity = "not a number"
      # Act
      result = @item.valid?
      # Asssert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "is not a number"
    end
  end

  describe "subtotal" do
    it "calculates the subtotal" do
      # Arrange
      # in the before block
      # Act
      result = @item.subtotal
      # Assert
      expect(result).must_be_kind_of Numeric
      expect(result).must_equal 200
    end

    it "returns zero if quantity is zero" do
      # Arrange
      @item.quantity = 0
      # Act
      result = @item.subtotal
      # Assert
      expect(result).must_be_kind_of Numeric
      expect(result).must_equal 0
    end
    
    it "returns zero if the product is invalid" do
      # Arrange
      @item.product_id = nil
      # Act
      result = @item.subtotal
      # Assert
      expect(result).must_be_kind_of Numeric
      expect(result).must_equal 0
    end
  end

end
