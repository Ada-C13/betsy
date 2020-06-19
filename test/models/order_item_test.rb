require "test_helper"

describe OrderItem do
  before do
    @order_item = OrderItem.create(name: "order_item1")
    @new_product = products(:product_1)
    @new_order = Order.create
    @valid_order_item = OrderItem.create(name: @new_product.name, price: @new_product.price, quantity: @new_product.inventory, product_id: @new_product.id, order_id: @new_order.id)
  end
  
  describe "validations" do
    it "is valid when parameter are present" do
      expect(@valid_order_item.valid?).must_equal true
    end
    
    it "is invalid without a name" do
      invalid_order_item = order_items(:order_item1)
      invalid_order_item.name = nil
      invalid_order_item.save
      expect(invalid_order_item.valid?).must_equal false
      expect(invalid_order_item.errors.messages).must_include :name
      expect(invalid_order_item.errors.messages[:name]).must_equal ["can't be blank"]
    end

  end
  
  describe "relations" do
    it "belongs to one product" do
      @valid_order_item.save
      expect(@valid_order_item.product).must_be_instance_of Product
    end

    it "belongs to one order" do
      @valid_order_item.save
      expect(@valid_order_item.order).must_be_instance_of Order
    end
  end

  describe "check product inventory" do
    it "returns true if inventory is available" do
      expect(@valid_order_item.check_product_inventory).must_equal true
    end

    it "returns false if inventory not available" do
      @valid_order_item.product.inventory = 0
      @valid_order_item.product.save
      expect(@valid_order_item.check_product_inventory).must_equal false
    end

    it "returns false if incoming quantity is nil" do
      @valid_order_item.quantity = nil
      @valid_order_item.save
      expect(@valid_order_item.check_product_inventory).must_equal false
    end

    it "returns false if incoming quantity is 0" do
      @valid_order_item.quantity = 0
      @valid_order_item.save
      expect(@valid_order_item.check_product_inventory).must_equal false
    end

    it "returns false if product is retired" do 
      @valid_order_item.product.status = false
      @valid_order_item.product.save
      expect(@valid_order_item.check_product_inventory).must_equal false
    end
  end

  describe "update_product_inventory" do
    it "returns true if product inventory is adequate for updating cart" do
      expect(order_items(:order_item4).update_product_inventory(1)).must_equal true
    end

    it "returns false if product inventory is inadequate for updating cart" do
      expect(order_items(:order_item4).update_product_inventory(10)).must_equal false      
    end
  end

  describe "check order item existence" do
    it "adds to cart if item does not already exist in cart" do
      product = products(:product_1)
      order_item = order_items(:order_item1)
      open_cart = orders(:order1)

      another_item = OrderItem.create(
        name: product.name,
        price: product.price,
        quantity: 2, 
        photo_url: product.photo_url,
        product_id: product.id, 
        order_id: open_cart.id
      )

      another_item.check_order_item_existence(open_cart.id)
      another_item.reload

      expect(order_item.quantity).must_equal 5
      expect(another_item.quantity).must_equal 2
      expect(open_cart.order_items.count).must_equal 2
    end
    
    it "updates item quantity in cart if it already exists" do
      order_item = order_items(:order_item1)
      another_item = order_items(:order_item1)
      open_cart = orders(:order1)

      another_item.check_order_item_existence(open_cart.id)
      another_item.reload

      expect(order_item.quantity).must_equal 10
      expect(open_cart.order_items.count).must_equal 1
    end
  end

  describe "reduce inventory" do
    it "reduces correctly" do
      expect{@valid_order_item.reduce_inventory}.must_change "Product.find(#{@valid_order_item.product.id}).inventory", 0 - @valid_order_item.quantity
    end
  end

  describe "add inventory" do
    it "adds correctly" do
      expected_inventory = @valid_order_item.quantity + @valid_order_item.product.inventory #5 +5

      @valid_order_item.add_inventory
      @valid_order_item.reload

      expect(@valid_order_item.product.inventory).must_equal expected_inventory
    end
  end

end

