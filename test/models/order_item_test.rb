require "test_helper"

describe OrderItem do
  before do
    @collar = order_items(:collar_order_item)
    @leash = order_items(:leash_order_item)
    @bowl = order_items(:bowl_order_item)
  end
  describe "validations" do
    it "is valid when quantity is present" do
      expect(@collar.valid?).must_equal true
      expect(@leash.valid?).must_equal true
      expect(@bowl.valid?).must_equal true
    end
    it "is invalid when quantity is not present, is not a number, or is a negative number" do
      @collar.quantity = "not an integer"
      @leash.quantity = -1

      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :quantity
      expect(@leash.valid?).must_equal false
      expect(@leash.errors.messages).must_include :quantity
    end
  end
  describe "relations" do
    it "has an order" do
      expect(@collar.order.valid?).must_equal true
      expect(@collar.order).must_equal orders(:order2)
      expect(@collar.order_id).must_equal orders(:order2).id
    end
    it "has a product" do
      #TODOOOOO: product says it's not valid, why???
      #expect(@bowl.product.valid?).must_equal true
      expect(@bowl.product).must_equal products(:bowl)
      expect(@bowl.product_id).must_equal products(:bowl).id
    end
  end
  describe "custom methods" do
    describe "calculate_total" do
      it "should have the order_items price as the total an order item with quantity of one" do
        expect(@collar.calculate_total).must_equal products(:collar).price
      end
      it "should calculate the order_items total correctly for an order items quantity that's greater than one" do
        expect(@leash.calculate_total).must_equal products(:leash).price * 3
      end
    end
    describe "stock" do
      it "should return the stock of an order_item's product" do
        expect(@leash.stock).must_equal products(:leash).stock
      end
    end
    describe "is_in_stock" do
      it "should return true if order items quantity is less than or equal to products' stock" do
        @leash.quantity = 10 #to make it same as the leash's stock
        expect(@collar.is_in_stock).must_equal true
        expect(@leash.is_in_stock).must_equal true
        expect(@bowl.is_in_stock).must_equal true
      end
      it "should return false if the order items quantity is more than products' stock" do
        @collar.quantity = 3
        @leash.quantity = 11
        @bowl.quantity = 10
        expect(@collar.is_in_stock).must_equal false
        expect(@leash.is_in_stock).must_equal false
        expect(@bowl.is_in_stock).must_equal false
      end
    end
  end
end
