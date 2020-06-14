require "test_helper"

describe OrderItem do
    describe "relations" do
      it "belongs to product" do
        expect(OrderItem.new).must_respond_to :product
      end
      it "belongs to order" do
        expect(OrderItem.new).must_respond_to :order
      end
    end
    
    describe "validations" do
      before do
      @order_item = order_items(:order_item1)
      end
      it "must have a quantity" do
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

  describe "subtotal" do
    it "calculates the item subtotal accurately" do
      order_item = order_items(:order_item1)
      expect(order_item.subtotal).must_be_close_to (4.4 + 4.4), 0.001
    end
  end
end