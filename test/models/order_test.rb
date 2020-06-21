require "test_helper"

describe Order do
  let(:paid_order) { orders(:order2) }
  let(:pending_order) { orders(:pending_order) }

  describe "validations" do
    it "will not allow Orders to have no status" do
      paid_order.status = nil

      expect(paid_order.valid?).must_equal false
      expect(paid_order.errors.messages).must_include :status
      expect(paid_order.errors.messages[:status]).must_include "can't be blank"
    end
  end

  it "cannot have a status other than pending, paid, cancelled or complete" do
    paid_order.status = "pending"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "paid"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "complete"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "cancelled"
    expect(paid_order.valid?).must_equal true

    paid_order.status = "gretchen"
    expect(paid_order.valid?).must_equal false
    expect(paid_order.errors.messages).must_include :status
    expect(paid_order.errors.messages[:status]).must_include "gretchen is not a valid status"
  end

  it "can update an Order with valid order data" do
    expect{ Orderitem.create(quantity: 1, order: pending_order, product: products(:rainier), shipped: false) }.must_change "pending_order.orderitems.count", 1

    expect{ 
      pending_order.update(
        email: "lady@gmail.com",
        address: "2020 my house street",
        cc_name: "Butterfly Cherry",
        cc_num: 41658214563,
        cvv: 589,
        cc_exp: "02/2023",
        zip: 98028,
        status: "paid"
      )
    }.wont_change "Order.count"

    expect(pending_order.email).must_equal "lady@gmail.com"
    expect(pending_order.address).must_equal "2020 my house street"
    expect(pending_order.cc_name).must_equal "Butterfly Cherry"
    expect(pending_order.cc_num).must_equal 41658214563
    expect(pending_order.cvv).must_equal 589
    expect(pending_order.cc_exp).must_equal "02/2023"
    expect(pending_order.zip).must_equal 98028
    expect(pending_order.status).must_equal "paid"
    expect(pending_order.orderitems.length).must_equal 1
  end

  # DO WE NEED THIS ONE? OR TEST INVALID DATA?
  it "cannot update an Order" do
    expect(pending_order.orderitems.count).must_equal 0

    expect( 
      pending_order.update(
        email: "lady@gmail.com",
        address: "2020 my house street",
        cc_name: "Butterfly Cherry",
        cc_num: 41658214563,
        cvv: 589,
        cc_exp: "02/2023",
        zip: 98028,
        status: "paid"
      )
    ).must_equal false

    # Does this pending order need to be referenced from fixtures differently?
    updated_order = Order.find_by(id: pending_order.id)

    expect(updated_order.email).must_be_nil
    expect(updated_order.address).must_be_nil
    expect(updated_order.cc_name).must_be_nil
    expect(updated_order.cc_num).must_be_nil
    expect(updated_order.cvv).must_be_nil
    expect(updated_order.cc_exp).must_be_nil
    expect(updated_order.zip).must_be_nil
    expect(updated_order.status).must_equal "pending"
  end

  it "will output errors if updating Orders without orderitems" do
    updated_order = pending_order.update(
      email: "lady@gmail.com",
      address: "2020 my house street",
      cc_name: "Butterfly Cherry",
      cc_num: 41658214563,
      cvv: 589,
      cc_exp: "02/2023",
      zip: 98028,
      status: "paid"
    )
    expect(updated_order).must_equal false
    expect(pending_order.errors.messages).must_include :orderitems
    expect(pending_order.errors.messages[:orderitems]).must_include "Your cart is empty"
  end

  #low hanging fruit :P
  describe "All attributes must be present when updating" do
    before do
      expect{ Orderitem.create(quantity: 1, order: pending_order, product: products(:rainier), shipped: false) }.must_change "pending_order.orderitems.count", 1
      
      @updated_order = pending_order.update(
        status: "paid"
      )
    end
    
    it "will not update an Order without an email" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :email
      expect(pending_order.errors.messages[:email]).must_include "can't be blank"
    end

    it "will not update an Order without an address" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :address
      expect(pending_order.errors.messages[:address]).must_include "can't be blank"
    end

    it "will not update an Order without a cc_name" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :cc_name
      expect(pending_order.errors.messages[:cc_name]).must_include "can't be blank"
    end

    it "will not update an Order without a cc_num" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :cc_num
      expect(pending_order.errors.messages[:cc_num]).must_include "can't be blank"
    end

    it "cannot update an Order with a non-numerical cc_num" do
      updated_order = paid_order.update(cc_num: "abc")
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :cc_num
      expect(paid_order.errors.messages[:cc_num]).must_include "is not a number"
    end

    it "cannot update an Order with a cc_num that is a float" do
      updated_order = paid_order.update(cc_num: 123.4)
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :cc_num
      expect(paid_order.errors.messages[:cc_num]).must_include "must be an integer"
    end

    it "cannot update an Order with a cc_num with less than 4 digits" do
      updated_order = paid_order.update(cc_num: 123)
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :cc_num
      expect(paid_order.errors.messages[:cc_num]).must_include "is too short (minimum is 4 characters)"
    end 

    it "will not update an Order without a cvv" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :cvv
      expect(pending_order.errors.messages[:cvv]).must_include "can't be blank"
    end

    it "cannot update an Order with a cvv that is a float" do
      updated_order = paid_order.update(cvv: 0.0)
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :cvv
      expect(paid_order.errors.messages[:cvv]).must_include "must be an integer"
    end

    it "cannot update an Order with a non-numerical cvv" do
      updated_order = paid_order.update(cvv: "abc")
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :cvv
      expect(paid_order.errors.messages[:cvv]).must_include "is not a number"
    end 

    it "will not update an Order ithout a cc_exp" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :cc_exp
      expect(pending_order.errors.messages[:cc_exp]).must_include "can't be blank"
    end
    
    it "will not update an Order ithout a zip" do
      expect(@updated_order).must_equal false
      expect(pending_order.errors.messages).must_include :zip
      expect(pending_order.errors.messages[:zip]).must_include "can't be blank"
    end
    
    it "cannot update an Order with a non-numerical zip" do
      updated_order = paid_order.update(zip: "abc")
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :zip
      expect(paid_order.errors.messages[:zip]).must_include "is not a number"
    end 
    
    it "cannot update an Order with a zip that is a float" do
      updated_order = paid_order.update(zip: 0.0)
      
      expect(updated_order).must_equal false
      expect(paid_order.errors.messages).must_include :zip
      expect(paid_order.errors.messages[:zip]).must_include "must be an integer"
    end
  end

  describe "relationships" do
    it "has many orderitems" do
      expect(paid_order.orderitems.count).must_be :>, 1
      
      paid_order.orderitems.each do |orderitem|
        expect(orderitem).must_be_instance_of Orderitem
      end
    end

    it "has many products" do
      expect(paid_order.products.count).must_be :>, 1
      
      paid_order.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "custom methods" do

    # def mark_as_complete!
    #   if self.status == "paid" && self.orderitems.find_by(shipped: false).nil?
    #     self.status = "complete"
    #     self.save!
    #     return true
    #   else
    #     return false
    #   end
    # end
    

    # describe "reduce_stock" do
    #   it "will reduce the number of product stock by orderitem quantity" do
    #     expect(products(:rx_bar).stock).must_equal 3
    #     expect(products(:kind).stock).must_equal 5
        
    #     paid_order.reduce_stock
        
    #     updated_rx_bar = Product.find_by(id: products(:rx_bar).id)
    #     updated_kind = Product.find_by(id: products(:kind).id)
        
    #     expect(updated_rx_bar.stock).must_equal 2
    #     expect(updated_kind.stock).must_equal 4
    #   end
    # end
  end
end
