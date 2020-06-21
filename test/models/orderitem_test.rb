require "test_helper"

describe Orderitem do
  describe "relations" do
    before do
      @orderitem = orderitems(:rxbar)
    end

    it "belongs to an order" do
      expect(@orderitem.order).must_equal orders(:order1)
    end

    it "belongs to a product" do
      expect(@orderitem.product).must_equal products(:rx_bar)
    end
  end

  describe "validations" do
    before do
      @orderitem = orderitems(:rxbar)
    end

    # QUANTITY VALIDATIONS:
    it "is valid with a valid integer quantity" do
      expect(@orderitem.valid?).must_equal true
      expect(@orderitem.quantity).must_be_kind_of Integer
      expect(@orderitem.quantity).must_equal 3
    end

    it "is invalid without a quantity" do
      @orderitem.quantity = nil
      @result = @orderitem.valid?

      expect(@result).must_equal false
    end

    it "is invalid with a quantity integer value less than or equal to 0" do
      # 0 quantity
      @orderitem.quantity = 0
      @result = @orderitem.valid?

      expect(@result).must_equal false

      # Negative quantity
      @orderitem.quantity = -1
      @result = @orderitem.valid?

      expect(@result).must_equal false
    end

    it "is invalid with an incorrect quantity data type" do
      @orderitem.quantity = "FIVE"
      @result = @orderitem.valid?

      expect(@result).must_equal false
    end

    # SHIPPED VALIDATIONS:
    # test message content????
    it "is valid with a false shipped status" do
      expect(@orderitem.valid?).must_equal true
      expect(@orderitem.shipped.class).must_equal FalseClass
      expect(@orderitem.shipped).must_equal false
    end

    # test message content????
    it "is valid with a true shipped status" do
      @orderitem = orderitems(:discover)

      expect(@orderitem.valid?).must_equal true
      expect(@orderitem.shipped.class).must_equal TrueClass
      expect(@orderitem.shipped).must_equal true
    end

    # TODO::: IN_STOCK VALIDATIONS


    # TODO::: NOT_RETIRED VALIDATIONS


  end

  # CUSTOM METHODS
  describe "subtotal" do
    before do
      @orderitem = orderitems(:rxbar)
    end

    it "correctly calculates the subtotal from an orderitem's corresponding product" do
      # 3 rx_bars * $2.45
      expect(@orderitem.quantity).must_equal 3
      expect(@orderitem.product.price).must_equal 2.45
      expect(@orderitem.subtotal).must_equal 7.35
    end

    it "returns 0 when the quantity is 0" do
      # 0 quantity
      @orderitem.quantity = 0
      expect(@orderitem.quantity).must_equal 0
      expect(@orderitem.product.price).must_equal 2.45
      expect(@orderitem.subtotal).must_equal 0
    end
  end
end
