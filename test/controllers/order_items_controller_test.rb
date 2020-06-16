require "test_helper"

describe OrderItemsController do
  before do
    @order_item = order_items(:order_item1)
  end

  describe "update" do
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

      expect(flash[:result_text]).must_include "Successfully updated the quantity of #{@order_item.product.title}"

      must_redirect_to cart_path
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
      
      expect(flash[:result_text]).must_include "#{@order_item.product.title} does not have enough quantity in stock"

      must_redirect_to cart_path
    end
  end

  describe "destroy" do
    it "destroys an existing order item, creates a flash message, then redirects" do
      expect{
        delete order_item_path(@order_item.id)
      }.must_differ "OrderItem.count", -1

      expect(flash[:result_text]).must_include "Successfully removed #{@order_item.product.title} from cart!"

      must_redirect_to cart_path
    end

    it "does not destroy the order item when given an invalid id, then responds with a 404 error" do
      expect{
        delete order_item_path(-1)
      }.wont_differ "OrderItem.count"

      must_respond_with :not_found
    end
  end

  describe "ship" do
    it "updates order and order_item statuses" do
      expect(@order_item.shipped).must_equal false
      post ship_item_path(@order_item.id)
      @order_item.reload
      expect(@order_item.shipped).must_equal true
      expect(@order_item.order.status).must_equal "complete"
      expect(flash[:result_text]).must_include "Successfully shipped"
      must_redirect_to merchant_path(@order_item.product.merchant.id)
    end

    it "doesn't update the order_item if it's already shipped" do
      expect(@order_item.shipped).must_equal false
      post ship_item_path(@order_item.id)
      @order_item.reload
      expect(@order_item.shipped).must_equal true
      post ship_item_path(@order_item.id)
      expect(@order_item.shipped).must_equal true
    end
  end
end
