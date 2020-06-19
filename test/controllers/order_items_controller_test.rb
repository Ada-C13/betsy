require "test_helper"
require "session_provider"


describe OrderItemsController do
  describe "Create an order Item" do
    it "can create an Order Item with a new Order" do
      product = products(:product_2)
      # assert that new Order is created
      expect { post product_order_items_path(product.id) }.must_differ "Order.count", 1

      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"

      item = OrderItem.find_by(product_id: product.id)

      order_nil = item.order_id.nil?

      expect(item.product_id).must_equal product.id
      expect(item.quantity).must_equal item.quantity
    end

    it "gets an error when adding a duplicate item with insufficient stock" do
      order = orders(:duplicate_order_item_order)
      product = products(:duplicate_order_item_product)
      product_id = product.id
      quantity = 2
      SessionProvider.with_session({order_id: order.id}) do
        post product_order_items_path(product_id, quantity: quantity)
      end

      expect(flash[:error]).must_equal "You cannot add more items than are in stock."
      must_respond_with :redirect
    end

    it "gets success when adding a duplicate item with sufficient stock" do
      order = orders(:duplicate_order_item_order)
      product = products(:duplicate_order_item_product)
      product_id = product.id
      quantity = 1
      SessionProvider.with_session({ order_id: order.id }) do
        post product_order_items_path(product_id, quantity: quantity)
      end

      expect(flash[:success]).must_equal "Successfully updated order item"
      must_respond_with :redirect
    end

    it "will not create an Order Item if product inventory is less than 1" do
      product = products(:product_2)
      product.update(inventory: 0)

      post order_items_path(@params)
      expect { post product_order_items_path(product.id) }.must_differ "OrderItem.count", 0
      expect(flash[:error]).must_equal "Could not add item to order! We have no stock available"
      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      @product = products(:product_2)
      @order = orders(:order_1)

      @params = {
        order_item: {
          order_id: @order.id,
          product_id: @product.id,
          quantity: 1,
        },
      }
      post order_items_path(@params)
      @item = OrderItem.find_by(product_id: @product)
    end

    it "succeeds for valid data and an existin order Item ID" do
      updates = { order_item: { quantity: 2 } }

      expect {
        patch order_item_path(@item), params: updates
      }.wont_change "OrderItem.count"

      updated_order_item = OrderItem.find_by(id: @item.id)

      expect(updated_order_item.quantity).wont_equal 6
      must_respond_with :redirect
    end

    it "shows an error if there is not enough inventory" do
      order_item = order_items(:order_item_1)

      updates = { order_item: { quantity: 3000 } }

      expect {
        patch order_item_path(order_item.id), params: updates
      }.wont_change "OrderItem.count"

      updated_order_item = OrderItem.find_by(id: order_item.id)

      expect(flash[:error]).must_equal "You cannot add more items than are in stock"
      expect(updated_order_item.quantity).wont_equal 3000
      must_respond_with :redirect
    end

    it "renders bad_request for invalid data" do
      updates = { order_item: { product_id: nil } }

      expect {
        patch order_item_path(@item), params: updates
      }.wont_change "OrderItem.count"

      updated_order_item = OrderItem.find_by(id: @item.id)

      expect(flash[:error]).must_equal "Your order items was not updated "
      must_respond_with :redirect
    end

    it "renders 404 not_found for order item id" do
      product = products(:product_2)
      bogus_id = product.id
      product.destroy

      patch order_item_path(bogus_id), params: { order_item: { quantity: 2 } }

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "succeeds for an  order Item ID" do
      item = order_items(:order_item_1)

      expect {
        delete order_item_path(item.id)
      }.must_change "OrderItem.count", -1

      must_respond_with :redirect
    end

    it "renders 404 not_found and does not update the DB for a invalid order item ID" do
      item = order_items(:order_item_1)
      item.id = -1

      expect {
        delete order_item_path(item.id)
      }.wont_change "OrderItem.count"

      must_respond_with :not_found
    end
  end
end
