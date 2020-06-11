require "test_helper"

describe OrderItemsController do
  describe "create" do
    before do
      @product = products(:apple)
    end
    
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

    it "creates a new pending order if there is no order_id stored in session" do
      expect {
        post product_add_path(@product.id), params: order_item_hash
      }.must_differ "Order.count", 1

      new_order = Order.last
      expect(session[:order_id]).must_equal new_order.id
      expect(new_order.status).must_equal "pending"
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
    before do
      @order_item = order_items(:order_item1)
    end

    let (:edited_order_item_hash) {
      {
        order_item: {
          quantity: 2,        
        },
      }
    }

    it "can update an existing order item with valid information accurately, flash success message, and redirect" do
      expect {
        patch order_item_path(@order_item.id), params: edited_order_item_hash
      }.wont_differ "OrderItem.count"

      @order_item.reload
      expect(@order_item.quantity).must_equal edited_order_item_hash[:order_item][:quantity]

      expect(flash[:success]).must_include "Successfully updated the quantity of #{@order_item.product.title}"

      must_redirect_to orders_path
    end

    it "does not update an order item if given an invalid id, and responds with a 404" do
      expect {
        patch order_item_path(-1), params: edited_order_item_hash
      }.wont_differ "OrderItem.count"

      must_respond_with :not_found
    end

    it "does not update an order item if the quantity requested is greater than product stock, flash error message, and responds with a 400 error" do
      invalid_order_item_hash = {
        order_item: {
          quantity: @order_item.product.stock + 1,
        },
      }

      expect {
        patch order_item_path(@order_item.id), params: invalid_order_item_hash
      }.wont_differ "OrderItem.count"
      
      expect(flash[:error]).must_include "A problem occurred: #{@order_item.product.title} does not have enough quantity in stock"

      must_redirect_to orders_path
    end
  end

  describe "destroy" do
  end
end
