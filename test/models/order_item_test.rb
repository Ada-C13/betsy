require "test_helper"

describe OrderItem do
  describe 'relationships' do
    it 'must belong to a Plant' do

    end

    it 'must belong to an Order' do

    end
  end

  describe 'validations' do
    before do 
      @order_item = OrderItem.new quantity: 2
    end

    it 'is valid if quantity is greater than 0' do
      result = @order_item.valid?
      expect(result).must_equal true
    end

    it 'is not valid if quantity is less than or equal to 0' do
      @order_item.quantity = 0
      result = @order_item.valid?

      expect(result).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
      expect(@order_item.errors.messages[:quantity]).must_include "must be greater than 0"
    end

    it 'is not valid if quantity is not present' do
      order_item = OrderItem.new
      result = order_item.valid?

      expect(result).must_equal false
      expect(order_item.errors.messages).must_include :quantity
      expect(order_item.errors.messages[:quantity]).must_include "can't be blank"
    end

    it 'is not valid if quantity is not a number' do
      @order_item.quantity = "not a number"
      result = @order_item.valid?

      expect(result).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
      expect(@order_item.errors.messages[:quantity]).must_include "is not a number"
    end
  end
end
