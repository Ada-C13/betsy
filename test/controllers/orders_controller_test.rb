require "test_helper"

describe OrdersController do
  describe "index" do
    it "can get index page" do
      get orders_path

      must_respond_with :ok
    end
  end

  describe "create " do
    it "can create a new order and set session order_id to new order id" do
      expect { post orders_path }.must_differ "Order.count", 1
      expect(session[:order_id]).must_equal Order.last.id
    end

    # it "will create a new order without setting session order_id if one exists" do
    #   perform_login
    #   expect{post orders_path}.must_differ "Order.count", 1
    #   expect(session[:order_id]).must_equal Order.last.id
    # end
  end

  describe "show" do
    it "flashes error message and redirects to root if no session order_id" do
      order = Order.first

      get order_path(order.id)

      expect(flash[:error]).must_equal "You haven't started an order yet. Add some items to your cart first!"
      must_redirect_to products_path
    end

    it "sets order and order_products if there is a session order_id" do
      order = create_order

      get order_path(order.id)

      expect(order.order_items.length).must_equal 1
    end
  end



  describe "edit" do
    it "responds with success for valid product" do
      # Act
      get edit_order_path(orders(:order_1))

      # Assert
      must_respond_with :success
    end

    it "returns error if items in cart no longer have enough quantity in stock" do
      order = orders(:order_1)

      order.order_items.each do |order_item|
        order_item.product.inventory = 0
        order_item.product.save!
      end

      get edit_order_path(order)

      expect(flash[:error]).must_equal "Some of the items in your cart are no longer in stock. We have updated your cart to reflect the current quantity."

      must_redirect_to order_path(order.id)
    end

    it "reduces quantity of order items if product inventory is less than order item quantity" do
      order = orders(:order_1)

      order.order_items.each do |order_item|
        order_item.quantity = 2
        order_item.save!
        order_item.product.inventory = 1
        order_item.product.save!
      end

      get edit_order_path(order)

      order.order_items.each do |order_item|
        expect(order_item.reload.quantity).must_equal 1
      end

      expect(flash[:error]).must_equal "Some of the items in your cart are no longer in stock. We have updated your cart to reflect the current quantity."
      must_redirect_to order_path(order.id)
    end
  end

  describe "update" do
    it "will update order " do
      order = orders(:order_1)
      order_hash = {
        order: {
          name: "updated jessica",
        },
      }

      expect { patch order_path(order.id), params: order_hash }.must_differ "Order.count", 0
      expect(order.reload.name).must_equal "updated jessica"
    end

    it "can not update orders with status paid" do
      paid_order = orders(:paid_order)
      order_hash = {
        order: {
          name: "updated bob",
        },
      }

      expect { patch order_path(paid_order.id), params: order_hash }.must_differ "Order.count", 0
      expect(flash[:error]).must_equal "This order has already been confirmed and can no longer take changes."
      must_redirect_to orders_path
      expect(paid_order.reload.name).must_equal "bob"
    end

    it "can not update order if no order items " do
      empty_order = orders(:order_with_no_items)

      order_hash = {
        order: {
          name: "updated bob",
        },
      }

      expect { patch order_path(empty_order.id), params: order_hash }.must_differ "Order.count", 0
      expect(flash[:error]).must_equal "You don't have any items in your cart. Add some items to your cart first!"
    end
  end

  describe "status" do
    it "can get status page" do
      order = Order.first

      get status_path(order.id)

      must_respond_with :ok
    end

    it "redirect if invalid order" do
      invalid_id = -1

      get status_path(invalid_id)

      must_redirect_to products_path
    end
  end

  describe "cancel_order and complete_order" do
    it "can cancel a paid order" do
      perform_login(merchants(:merchant_1))
      order_to_cancel = orders(:cancel_order_paid)
      patch cancel_order_path(order_to_cancel.id)

      expect(order_to_cancel.reload.status).must_equal "cancelled"
    end

    it "can cancel a paid order" do
      perform_login(merchants(:merchant_1))
      order_to_cancel = orders(:cancel_order_paid)
      patch complete_order_path(order_to_cancel.id)

      expect(order_to_cancel.reload.status).must_equal "complete"
    end
  end
end
