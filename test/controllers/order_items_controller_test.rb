require "test_helper"


describe OrderItemsController do
  let (:good_qty_hash) {
    { quantity: 1 }
  }
  let (:zero_qty_hash) {
    { quantity: 0 }
  }
  let (:bad_qty_hash) {
    { quantity: 1000 }
  }
  let (:nil_qty_hash) {
    { quantity: 1000 }
  }
  let (:product) { products(:product1) }
  let (:pending_items) {
    OrderItem.all.find_all {|item| item.status == "pending"}
  }
  let (:paid_items) {
    OrderItem.all.find_all {|item| item.status == "paid"}
  }
  let (:cancelled_items) {
    OrderItem.all.find_all {|item| item.status == "cancelled"}
  }
  let (:shipped_items) {
    OrderItem.all.find_all {|item| item.status == "shipped"}
  }
  let (:all_paid_items) {
    [paid_items, cancelled_items, shipped_items]
  }
    
  describe "create" do
    # much more testing of this is in cart testing in order_controller_test
    it "can create a new order_item with valid information accurately" do
      expect {
        post add_order_item_path(product), params: good_qty_hash
      }.must_differ "OrderItem.count", 1
      expect(OrderItem.last.quantity).must_equal good_qty_hash[:quantity]
      expect(OrderItem.last.product_id).must_equal product.id
      expect(OrderItem.last.status).must_equal "pending"
      expect(flash[:success]).must_equal "Added #{good_qty_hash[:quantity]} of #{product.name} to cart."
      must_redirect_to cart_path
    end
    it "responds with error when given bad qty, 0" do 
      expect {
        post add_order_item_path(product), params: zero_qty_hash
      }.must_differ "OrderItem.count", 0
      expect(flash[:error]).must_equal "Unable to add #{zero_qty_hash[:quantity]} of #{product.name} to cart"
      must_redirect_to product_path(product)
    end
    it "responds with error when given bad qty, nil" do 
      expect {
        post add_order_item_path(product), params: nil_qty_hash
      }.must_differ "OrderItem.count", 0
      expect(flash[:error]).must_include "select another quanity."
      expect(flash[:error]).must_include "#{product.name}"
      must_redirect_to product_path(product)
    end
    it "responds with error when given too much qty" do 
      expect {
        post add_order_item_path(product), params: bad_qty_hash
      }.must_differ "OrderItem.count", 0
      expect(flash[:error]).must_include "select another quanity."
      expect(flash[:error]).must_include "#{product.name}"
      must_redirect_to product_path(product)
    end
    it "responds with redirect when item already in cart" do
      post add_order_item_path(product), params: good_qty_hash
      item = OrderItem.last
      post add_order_item_path(product), params: good_qty_hash
      expect(flash[:redirect]).must_equal "#{product.name.titleize} already in cart. Edit quantity here:"
      must_redirect_to order_item_path(item)
    end
  end


  describe "edit" do
    before do
      @p1 = products(:product1)
      @quantity_hash = {
        quantity: 1
      }
    end

    it "can't edit the quantity if the item is not in your cart" do
      post add_order_item_path(@p1), params: @quantity_hash
      expect(session[:cart_id]).must_equal Order.last.id
      order_exist = Order.last.id
      get order_item_path(order_items(:order_item1))
      expect(flash[:error]).must_equal "This item is not in your cart!"
    end
  end

  describe "update" do
    before do
      post add_order_item_path(product), params: good_qty_hash
      @item = OrderItem.last
    end
    it "updates qty" do
      update_good = {order_item: good_qty_hash}
      patch order_item_path(@item), params: update_good
      expect(flash[:success]).must_equal "Changed quantity to #{@item.quantity}."
      must_redirect_to cart_path
    end
    it "flashes error when qty too much" do
      update_bad = {order_item: bad_qty_hash}
      patch order_item_path(@item), params: update_bad
      expect(flash[:error]).must_include "select another quanity."
      expect(flash[:error]).must_include "#{product.name}"
      must_redirect_to cart_path
    end
    it "flashes error when qty 0" do
      update_bad = {order_item: zero_qty_hash}
      patch order_item_path(@item), params: update_bad
      expect(flash[:error]).must_equal "Unable to add 0 of #{@item.product.name} to cart"
      must_redirect_to cart_path
    end
  end
  describe "ship, when logged in" do
    before do 
      @merchant = merchants(:merchantaaa)
      @item = paid_items.sample
    end
    it "returns login error if not logged in" do
      patch ship_path({merchant_id: @merchant.id, id: @item.id})
      expect(flash[:error]).must_equal "You must be logged in to do that!"
      must_redirect_to root_path
    end
    it "successfully ships item" do
      perform_login(@merchant)
      patch ship_path({merchant_id: @merchant.id, id: @item.id})
      expect(flash[:success]).must_equal "Notified customer that #{@item.product.name.titleize} has been shipped."
      must_redirect_to merchant_orders_path(merchant_id: @merchant.id)
    end
    it "returns 404 when not found" do
      perform_login(@merchant)
      patch ship_path({merchant_id: @merchant.id, id: 10000000000})
      must_respond_with :not_found
    end
  end
  describe "destroy" do
    it "successfully destroys item from cart" do
      item = pending_items.sample
      expect{delete order_item_path(item)}.must_differ 'OrderItem.count', -1
      expect(flash[:success]).must_equal "Item removed from cart"
      must_redirect_to cart_path
    end
    it "flashes error, redirects to root when the item isn't pending" do
      non_pending_items = []
      all_paid_items.each do |type|
        non_pending_items << type.sample
      end
      non_pending_items.each do |item|
        delete order_item_path(item)
        expect(flash[:error]).must_equal "That item can't be deleted, it is #{item.status}"
        must_redirect_to root_path
      end
    end
  end

end
