require "test_helper"

describe OrderItem do
  before do
    @order_item = order_items(:order_item_too)
    describe "relations" do
      it "belongs to product" do
        expect(OrderItem.new).must_respond_to :product
      end
      it "belongs to order" do
        expect(OrderItem.new).must_respond_to :order
      end
    end
    
    describe "validations" do
      it "must have a quantity"
      expect(@order_item.valid?).must_equal true
    end
    it "must have a positive integer as quantity" do
      @order_item.quantity = 0
      expect(@order_item.valid?).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
    end
    it "is invalid without a quantity" do
      @order_item.quantity =  nil
      expect(@order_item.valid?).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
    end
  end
end