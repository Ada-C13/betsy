require "test_helper"

describe OrderItemsController do

  let (:order) { orders(:order_pending) }
  let (:merchant) { merchants(:suely) }
  let (:product) { products(:tulip) }

  before do
    order.save!
    merchant.save!

    product.merchant_id = merchant.id
    product.price = 100
    product.save!
  end

  describe "create" do
    it "Can add a valid item" do
      # Arrange
      # in the before block
      # Act & Assert
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.must_change "OrderItem.count", 1
      new_item = OrderItem.last
      expect(new_item).wont_be_nil
      expect(new_item.product.id).must_equal product.id
      expect(new_item.quantity).must_equal 2
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "Assumes quantity 1 if no quantity" do
      # Arrange
      # in the before block
      # Act & Assert
      expect {
        post create_order_items_path(product.id)
      }.must_change "OrderItem.count", 1
      new_item = OrderItem.last
      expect(new_item).wont_be_nil
      expect(new_item.product.id).must_equal product.id
      expect(new_item.quantity).must_equal 1
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "updates quantity if product already in cart" do
      # Arrange
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.must_change "OrderItem.count", 1
      new_item = OrderItem.last
      expect(new_item).wont_be_nil
      expect(new_item.product.id).must_equal product.id
      expect(new_item.quantity).must_equal 2
      must_respond_with :redirect
      must_redirect_to cart_path
      # Act & Assert
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.wont_change "OrderItem.count"
      new_item.reload
      expect(new_item.quantity).must_equal 4
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "can't add a bad product ID" do
      # Arrange
      # in the before block
      # Act & Assert
      expect {
        post create_order_items_path(0), params: { order_item: { quantity: 2 } }
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "Can't add a product w/o enough stock" do
      # Arrange
      product.stock = 3
      product.save!
      # Act & Assert
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 4 } }
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "Can't add a retired product" do
      # Arrange
      product.active = false
      product.save!
      # Act & Assert
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "can't add quantity above stock" do
      # Arrange
      product.stock = 3
      product.save!
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.must_change "OrderItem.count", 1
      new_item = OrderItem.last
      expect(new_item).wont_be_nil
      expect(new_item.product.id).must_equal product.id
      expect(new_item.quantity).must_equal 2
      must_respond_with :redirect
      must_redirect_to cart_path

      # Act & Assert
      expect {
        post create_order_items_path(product.id), params: { order_item: { quantity: 2 } }
      }.wont_change "OrderItem.count"
      must_respond_with :redirect
      must_redirect_to cart_path
    end
  end # describe "create"

  describe "destroy" do
    it "removes an existing item" do
      # Arrange
      item1 = OrderItem.new(
        order_id: order.id,
        product_id: product.id,
        quantity: 2
      )
      item1.save!
      current_count = OrderItem.count
      # Act & Assert
      delete order_item_path(item1)
      expect(OrderItem.count).must_equal current_count - 1
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "fails to remove an item after order checkout" do
      # Arrange
      item1 = OrderItem.new(
        order_id: order.id,
        product_id: product.id,
        quantity: 2
      )
      item1.save!
      current_count = OrderItem.count
      # Act & Assert
      item1.order.checkout_order!
      delete order_item_path(item1)
      expect(OrderItem.count).must_equal current_count
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "fails to remove a bad item" do
      # Arrange
      current_count = OrderItem.count
      # Act & Assert
      delete order_item_path(0)
      expect(OrderItem.count).must_equal current_count
      must_respond_with :redirect
      must_redirect_to cart_path
    end    
  end # describe "destroy"

end # describe OrderItemsController
