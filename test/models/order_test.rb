require "test_helper"

describe Order do
  let (:user) {User.create(name: "rachel", email_address: "rachel@ajonisle.com", uid: "420")}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}
  let (:product2) {Product.create(name: "pedal board", description: "a pedal board", price: 150, inventory: 3, photo_url: "https://villagerdb.com/images/items/thumb/pedal-board.ff406c9.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}  
  let (:order2) {Order.create(status: "pending")}
  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}
  let (:orderitem2) {OrderItem.create(order_id: order.id, product_id: product2.id, quantity: 2)}
  let (:orderitem3) {OrderItem.create(order_id: order.id, product_id: product2.id, quantity: 2, complete: true)}

  describe "custom methods" do 
    describe "total" do
      it "returns total for order with no orderitems" do
        result = order.total
        
        expect(result).must_equal 0
      end
      
      it "returns total for an order with one orderitem" do
        order.save
        orderitem.save
        
        result = order.total

        product = Product.find_by(id: orderitem.product_id)
        expected_result = orderitem.quantity * product.price
        
        expect(result).must_equal expected_result
      end
      
      it "returns total for order with more than one orderitems" do
        order.save
        orderitem.save
        orderitem2.save
        
        result = order.total
        product_1 = Product.find_by(id: orderitem.product_id)
        product_2 = Product.find_by(id: orderitem2.product_id)
        expected_result = (orderitem.quantity * product_1.price) + (orderitem2.quantity * product_2.price)
        
        expect(result).must_equal expected_result
      end
    end

    describe "Order.get_items" do 
      it "returns a product name" do 
        merchant_products = Product.first(10)
        item = Order.get_items(merchant_products)

        expect(item).must_equal "dog nose"
        expect(item).must_be_kind_of String
      end
    end

    describe "mark_shipped" do 
      it "can mark an order as shipped" do 
        new_order = orders(:order1)
        expect(new_order.status).must_equal "pending"
        new_order.mark_shipped 
        expect(new_order.status).must_equal "shipped"
      end
    end
  end
end
