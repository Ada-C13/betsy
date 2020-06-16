require "test_helper"

# 1nominal test
# if no session[cart_id] => create the Order PLUS create the seesion
# has session[cart_id]
# to chechk if product_id (must_be_instance_of) and prder_id (must_be_instance_of) is not empty
# clear the cart, the session[cart_id] will still exist
# if the product is already in the cart => flash message PLUS the redirect path.
# if the order_item is not saved we have to tests the flash and the redirect

# edge cases
# if we dont have quantity
# if product is nil => flash[:error] = “product is not exited”

# expect(session[:merchant_id]).must_equal merchant.id

describe OrdersController do
  before do
    @p1 = products(:product1)
    @quantity_hash = {
      quantity: 1
    }
  end
  describe "create cart" do
    it "create new Order and track it's session id" do
      get cart_path
      expect(session[:cart_id]).must_equal Order.last.id
    end

    it "doesn't create duplicate carts in one session, cart_path" do
      get cart_path
      expect(session[:cart_id]).must_equal Order.last.id
      order_exist = Order.last.id
      get cart_path
      expect(session[:cart_id]).must_equal order_exist
    end
    it "doesn't create duplicate carts in one session, add_order_item_path" do
      post add_order_item_path(@p1), params: @quantity_hash
      expect(session[:cart_id]).must_equal Order.last.id
      order_exist = Order.last.id
      post add_order_item_path(products(:product2)), params: @quantity_hash
      expect(session[:cart_id]).must_equal order_exist
    end
    it "saves order_item" do
      post add_order_item_path(@p1), params: @quantity_hash
      cart = Order.find_by(id: session[:cart_id])
      order_item = cart.order_items.first
      expect(order_item.product.id).must_equal @p1.id
      expect(flash[:success]
        ).must_equal "Added #{order_item.quantity} of #{@p1.name} to cart."
      must_redirect_to product_path(@p1)
    end
    it "doesn't save order item if there's not enough enough stock" do
      too_much = {
        quantity: @p1.stock + 1
      }
      post add_order_item_path(@p1), params: too_much
      cart = Order.find_by(id: session[:cart_id])
      expect(flash[:error]
        ).must_equal "There are only #{@p1.stock} #{@p1.name} in stock, please select another quanity."
      must_redirect_to product_path(@p1)
    end
    it "returns right error for 0 stock" do
      post add_order_item_path(products(:product0)), params: @quantity_hash
      expect(flash[:error]).must_equal "OUT OF STOCK"
      must_redirect_to product_path(products(:product0))
    end
    it "has right number of order_items" do
      product_count = 0
      Product.all.each do |product|
        if product.stock > 0
          post add_order_item_path(product), params: @quantity_hash
          product_count += 1
        end
      end
      cart = Order.find_by(id: session[:cart_id])
      expect(cart.order_items.length).must_equal product_count
    end
    it "redirects/flashes correctly if adding existing product in cart again" do
      post add_order_item_path(@p1), params: @quantity_hash
      cart = Order.find_by(id: session[:cart_id])
      existing_order_item = cart.order_items.last
      post add_order_item_path(@p1), params: @quantity_hash
      expect(flash[:redirect]).must_equal "#{@p1.name} already in cart. Edit quantity here:"
      must_redirect_to order_item_path(existing_order_item)
    end
  end
  
  describe "clear_cart" do
    it "remove all order_items from a cart with one item" do
      post add_order_item_path(@p1), params: @quantity_hash
      cart = Order.find_by(id: session[:cart_id])
      patch cart_path
      expect(flash[:success]).must_equal "Cart cleared."
      expect(cart.order_items.length).must_equal 0
      must_redirect_to cart_path
    end
    it "removes all order_items from cart with many items" do
      Product.all.each do |product|
        if product.stock > 0
          post add_order_item_path(product), params: @quantity_hash
        end
      end
      cart = Order.find_by(id: session[:cart_id])
      patch cart_path
      expect(cart.order_items.length).must_equal 0
    end
    it "returns not_found when cart not found" do
      patch cart_path
      must_respond_with :not_found
    end
    it "clearing empty cart doesn't break anything" do
      get cart_path
      patch cart_path
      cart = Order.find_by(id: session[:cart_id])
      expect(cart.order_items.length).must_equal 0
    end
  end
  describe "submitted/submitting orders" do
      let(:good_submit) {{
        order: {
        name: 'Lak',
        email: 'lak@ada.org',
        address: '244 Thomas str',
        cc_last_four: '2340',
        cc_exp_month: '10',
        cc_exp_year: '2024',
        cc_cvv: '543'
        }
      }}
      let(:bad_submit) {{
        order: {
        name: 'Lak',
        email: 'lak&ada.org',
        address: '',
        cc_last_four: '2340',
        cc_exp_month: '',
        cc_exp_year: '2024',
        cc_cvv: '543'
        }
      }}
    describe "checkout form" do
    end

    describe "submit_order" do
      it "flashes/redirects correctly after GOOD submit, cart session is reset" do  
        post add_order_item_path(@p1), params: @quantity_hash
        order = Order.find_by(id: session[:cart_id])
        patch checkout_path, params: good_submit
        expect(session[:cart_id]).must_equal nil
        expect(flash[:success]).must_equal "Your order has been submitted!"
        must_redirect_to complete_order_path(order)
      end
      it "flashes/renders correctly after BAD submit, cart session is NOT reset" do  
        post add_order_item_path(@p1), params: @quantity_hash
        order = Order.find_by(id: session[:cart_id])
        patch checkout_path, params: bad_submit
        expect(session[:cart_id]).must_equal order.id
        expect(flash[:error]).must_include "address"
        expect(flash[:error]).must_include "cc_exp_month"
        expect(flash[:error]).must_include "can't be blank"
      end
    end

    describe "show_complete" do
    end

    describe "cancel" do
      it "cancels paid order" do
        post complete_order_path(orders(:paid_order))
        expect(flash[:success]).must_equal "Your order was cancelled."
        must_redirect_to root_path
      end
      it "flashes user if order has already been shipped" do
        shipped = orders(:shipped_order)
        post complete_order_path(shipped)
        expect(flash[:error]).must_equal 'Order has already been shipped'
        must_redirect_to complete_order_path(shipped)
      end
    end
  end

end
