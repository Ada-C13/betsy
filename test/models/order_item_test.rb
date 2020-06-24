require "test_helper"

describe OrderItem do
  let (:user) { User.create(name: "Kat", email_address: "kat@ajonisle.com", uid: 32432)}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending")}
  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}
  let (:pending_order) {Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}

  describe "initialize" do
    it "can be instantiated" do
      expect(orderitem.valid?).must_equal true 
    end

    it "has required fields" do
      orderitem.save

      [:order_id, :product_id, :quantity, :complete].each do |field|
        expect(orderitem).must_respond_to field
      end
    end
  end

  describe "validations" do
    it "must have a product_id" do
      orderitem.product_id = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product_id
      expect(orderitem.errors.messages[:product_id]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have a valid product_id" do
      orderitem.product_id = -1
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product_id
      expect(orderitem.errors.messages[:product_id]).must_equal ["must be greater than 0"]
    end
    
    it "must have a quantity" do
      orderitem.quantity = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end
    
    it "must have a quantity greater than 0" do
      orderitem.quantity = 0
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end
    
    it "has a default for complete as false" do
      orderitem.save
      
      expect(orderitem.valid?).must_equal true
      expect(orderitem.complete).must_equal false
    end
  end

  describe "custom methods" do
    describe "OrderItem.cart_count" do 
      it "returns the number of items in the cart" do 
        session = Hash.new
        session[:cart] = [{'product_id' => 12, 'quantity' => 5}]

        expect(OrderItem.cart_count(session)).must_equal 5
      end
    end
  end
end
