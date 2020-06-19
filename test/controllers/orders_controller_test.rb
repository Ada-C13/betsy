require "test_helper"

describe OrdersController do

  before do
    @merchant = Merchant.create(
      username: 'Leroy Jenkins',
      email: 'leroy@gmail.com'
    )
    @product = Product.create(
      name: 'Plant One', 
      price: 5.00, 
      description: 'This is a fake plant.',
      inventory: 5,
      merchant_id: @merchant.id
    )
  end
  
  let (:new_item_hash) {
    {
      order_item: {
        name: @product.name,
        price: @product.price,
        quantity: 1,
        product_id: @product.id
      }
    }
  }
  
  describe "index" do
    it "responds with success when there are many orders saved" do
      new_order = Order.create
      get orders_path
      must_respond_with :found
    end

    it "responds with success when there are no orders saved" do
      OrderItem.destroy_all
      Order.destroy_all

      expect(Order.count).must_equal 0
      get orders_path
      must_respond_with :found
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid order" do
      perform_login(merchants(:merchant_1))
      #new_order = Order.create
      new_order = orders(:order1)
      get order_path(new_order.id)
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid order id" do
      perform_login(merchants(:merchant_1))
      get order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:update_hash) {
      {
        order: {
          guest_name: 'Leroy Jenkins',
          email: 'leroyj@gmail.com',
          phone_num: "(456)123-1234",
          address: '444 Main Street',
          city: 'Somewhere',
          state: 'CA',
          zip_code: '91007',
          card_number: '1234567890123456',
          card_expiration_date: '06/25',
          card_cvv: '333',
        }
      }
    }

    it "can update an existing order with valid information accurately, and redirect" do
      new_order = Order.create

      expect {
        patch order_path(new_order.id), params: update_hash
      }.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to confirmation_path

      find_order = Order.find_by(id: new_order.id)

      expect(find_order.guest_name).must_equal update_hash[:order][:guest_name]
      expect(find_order.email).must_equal update_hash[:order][:email]
      expect(find_order.address).must_equal update_hash[:order][:address]
      expect(find_order.city).must_equal update_hash[:order][:city]
      expect(find_order.state).must_equal update_hash[:order][:state]
      expect(find_order.zip_code).must_equal update_hash[:order][:zip_code]
      expect(find_order.card_number).must_equal update_hash[:order][:card_number]
      expect(find_order.card_expiration_date).must_equal update_hash[:order][:card_expiration_date]
      expect(find_order.card_cvv).must_equal update_hash[:order][:card_cvv]
    end

    it "does not update any order if given an invalid id, and responds with a 404" do
      expect {
        patch order_path(-1), params: update_hash
      }.wont_change 'Order.count'

      must_respond_with :not_found
    end

    it "does not update a order if the form data violates form validations, and responds with a redirect" do
      new_order = Order.create

      update = {
        order: {
          name: '',
        }
      }

      expect {
        patch order_path(new_order.id), params: update
      }.wont_change 'Order.count'
    end
  end

  describe "cart" do
    it "finds a list of orders if session order is populated" do
      get cart_path
      must_respond_with :success
    end
  end

  describe "checkout" do
    it "must respond with success if cart has items" do
      valid_cart = Order.create
      valid_item = OrderItem.create(
				name: @product.name,
				price: @product.price,
				quantity: 1,
				product_id: @product.id,
				photo_url: 'order.jpg',
				order_id: valid_cart.id
			)

      get checkout_path
      must_respond_with :found
    end

    it "redirects back to cart path if there are no items" do
      empty_cart = Order.create

      get checkout_path

      must_redirect_to cart_path
    end

    it "redirects back to cart path if no open cart has been made" do
      bad_cart = Order.create(cart_status: false)

      get checkout_path

      must_redirect_to cart_path
    end
  end

  describe "confirmation" do
    it "responds with success if confirmation is loaded" do
      valid_cart = Order.create
      valid_item = OrderItem.create(
				name: @product.name,
				price: @product.price,
				quantity: 1,
				product_id: @product.id,
				photo_url: 'order.jpg',
				order_id: valid_cart.id
      )
      get confirmation_path

      must_respond_with :found
      
      @test_product1 = products(:product_1)
      post product_order_items_path(@test_product1.id), params: new_item_hash

      get confirmation_path
    end

    it "responds with redirect if open cart is not found" do
      bad_cart = Order.create(cart_status: false)

      get checkout_path

      must_redirect_to cart_path
    end

    it "responds with redirect if no items are in the cart" do
      empty_cart = Order.create

      get checkout_path

      must_redirect_to cart_path

      expect(session[:order_id]).must_be_nil
    end
  end
end