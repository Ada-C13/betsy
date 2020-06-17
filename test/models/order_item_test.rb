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
  
  describe "relationships" do
    it "must belong to a Product" do
      # Arrange & Act
      # in the before block
      # Assert
      expect(@item).must_respond_to :product
      expect(@item.product).must_be_kind_of Product
    end

    it "must belong to an Order" do
      # Arrange & Act
      # in the before block
      # Assert
      expect(@item).must_respond_to :order
      expect(@item.order).must_be_kind_of Order
    end
  end # describe "relationships"

  describe "validations" do
    it "is valid if quantity is greater than 0" do
      # Arrange
      # in the before block
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal true
    end

    it "is not valid if quantity is less than or equal to 0" do
      # Arrange
      @item.quantity = 0
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "must be greater than 0"
    end

    it "is not valid if quantity is not present" do
      # Arrange
      @item.quantity = nil
      # Act
      result = @item.valid?
      # Assert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "can't be blank"
    end

    it "is not valid if quantity is not a number" do
      # Arrange
      @item.quantity = "not a number"
      # Act
      result = @item.valid?
      # Asssert
      expect(result).must_equal false
      expect(@item.errors.messages).must_include :quantity
      expect(@item.errors.messages[:quantity]).must_include "is not a number"
    end
  end # describe 'validations'

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
  end # describe "subtotal"

  describe "self.add_item" do

    let (:order1) { Order.new(status: "pending") }
    let (:merchant1) { merchants(:suely) }
    let (:product1) { products(:tulip) }
  
    before do
      order1.save!
      merchant1.save!
      product1.merchant_id = merchant1.id
      product1.price = 100
      product1.save!
    end
      
    it "adds a new item to the order" do
      # Arrange
      # in the before block
      # Act
      message = OrderItem.add_item(order1.id, product1.id, quantity = 2)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_nil
      expect(item1).must_be_kind_of OrderItem
      expect(item1.quantity).must_be_kind_of Numeric
      expect(item1.quantity).must_equal 2
    end

    it "adds to an existing item in the order" do
      # Arrange
      # in the before block
      # Act
      message1 = OrderItem.add_item(order1.id, product1.id, quantity = 2)
      message2 = OrderItem.add_item(order1.id, product1.id, quantity = 3)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message1).must_be_nil
      expect(message2).must_be_nil
      expect(item1).must_be_kind_of OrderItem
      expect(item1.quantity).must_be_kind_of Numeric
      expect(item1.quantity).must_equal 5
    end 

    it "returns error if the order is invalid" do
      # Arrange
      # in the before block
      # Act
      message = OrderItem.add_item(-1, product1.id, quantity = 1)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "order"
      expect(item1).must_be_nil
    end

    it "returns error if the order is not pending" do
      # Arrange
      order2 = Order.new(status: "cancelled")
      order2.save!
      # Act
      message = OrderItem.add_item(order2.id, product1.id, quantity = 1)
      item1 = OrderItem.find_by(order_id: order2.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "cannot be changed"
      expect(item1).must_be_nil
    end

    it "returns error if the product is invalid" do
      # Arrange
      # in the before block
      # Act
      message = OrderItem.add_item(order1.id, nil, quantity = 1)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "product"
      expect(item1).must_be_nil
    end

    it "returns error if the product is retired" do
      # Arrange
      product1.active = false
      product1.save!
      # Act
      message = OrderItem.add_item(order1.id, product1.id, quantity = 1)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "retired"
      expect(item1).must_be_nil
    end
    
    it "returns error if quantity is invalid" do
      # Arrange
      # in the before block
      # Act
      message = OrderItem.add_item(order1.id, product1.id, quantity = 0)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "quantity"
      expect(item1).must_be_nil
    end
    
    it "return error if quantity is higher than stock" do
      # Arrange
      product1.stock = 2
      product1.save!
      # Act
      message = OrderItem.add_item(order1.id, product1.id, quantity = 3)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "stock"
      expect(item1).must_be_nil
    end

    it "return error if added quantity higher than stock" do
      # Arrange
      product1.stock = 2
      product1.save!
      # Act
      message1 = OrderItem.add_item(order1.id, product1.id, quantity = 2)
      message2 = OrderItem.add_item(order1.id, product1.id, quantity = 1)
      item1 = OrderItem.find_by(order_id: order1.id, product_id: product1.id)
      # Assert
      expect(message1).must_be_nil
      expect(message2).must_be_kind_of String
      expect(message2.downcase).must_include "stock"
      expect(item1).must_be_kind_of OrderItem
      expect(item1.quantity).must_be_kind_of Numeric
      expect(item1.quantity).must_equal 2
    end
  end # describe "self.add_item"
  
  describe "update_item" do
    it "updates the quantity on an item" do
      # Arrange
      # in the before block
      # Act
      message = @item.update_item(1)
      # Assert
      expect(message).must_be_nil
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 1
    end

    it "returns error if the order is not pending" do
      # Arrange
      order.checkout_order!
      @item.reload
      # Act
      message = @item.update_item(1)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "cannot be changed"
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 2
    end

    it "returns error if the product is retired" do
      # Arrange
      product.active = false
      product.save!
      @item.reload
      # Act
      message = @item.update_item(1)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "retired"
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 2
    end
    
    it "returns error if quantity is invalid" do
      # Arrange
      # in the before block
      # Act
      message = @item.update_item(0)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "quantity"
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 2
    end
    
    it "return error if quantity is higher than stock" do
      # Arrange
      product.stock = 3
      product.save!
      @item.reload
      # Act
      message = @item.update_item(4)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "stock"
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 2
    end
  end # describe "update_item"
  
  describe "remove_item" do
    it "removes an item" do
      # Arrange
      old_item_id = @item.id
      # Act
      message = @item.remove_item
      old_item = OrderItem.find_by(id: old_item_id)
      # Assert
      expect(message).must_be_nil
      expect(old_item).must_be_nil
    end
    
    it "returns error if the order is not pending" do
      # Arrange
      order.checkout_order!
      @item.reload
      old_item_id = @item.id
      # Act
      message = @item.remove_item
      old_item = OrderItem.find_by(id: old_item_id)
      # Assert
      expect(message).must_be_kind_of String
      expect(message.downcase).must_include "cannot be changed"
      expect(@item).must_be_kind_of OrderItem
      expect(@item.quantity).must_be_kind_of Numeric
      expect(@item.quantity).must_equal 2
    end
  end # describe "remove_item"

end # describe OrderItem