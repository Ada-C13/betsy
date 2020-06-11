require "test_helper"

describe OrderItemsController do
  before do
    @product = products(:apple)
  end

  describe "create" do
    let (:order_item_hash) {
      {
        product: {
          quantity: 1,
        },
      }
    }

    it "can create a new order item with valid information accurately, and redirect" do
      expect {
        post product_add_path(@product.id), params: order_item_hash
      }.must_differ "OrderItem.count", 1
      
      new_order_item = OrderItem.find_by(product_id: @product.id)
      expect(new_order_item.order_id).must_equal session[:order_id]
      expect(new_order_item.quantity).must_equal order_item_hash[:product][:quantity]
      expect(new_order_item.shipped).must_equal false

      expect(flash[:success]).must_include "Successfully added #{@product.title} to cart!"
      
      must_redirect_to product_path(new_order_item.product_id)
    end

    it "creates a new order if there is no order_id stored in session" do
      expect {
        post product_add_path(@product.id), params: order_item_hash
      }.must_differ "Order.count", 1

      expect(session[:order_id]).must_equal Order.last.id
    end

    it "does not create an order item if the product_id is invalid, and responds with a 404" do
      expect {
        post product_add_path(-1), params: order_item_hash
      }.wont_differ "OrderItem.count"

      must_respond_with :not_found
    end

    it "does not create an order item if the quantity requested is greater than the product stock" do
      invalid_order_item_hash = {
        product: {
          quantity: @product.stock + 1,
        },
      }

      expect {
        post product_add_path(@product.id), params: invalid_order_item_hash
      }.wont_differ "OrderItem.count"

      expect(flash[:error]).must_include "A problem occurred: #{@product.title} does not have enough quantity in stock"

      must_redirect_to product_path(@product.id)
    end
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
