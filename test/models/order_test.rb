# frozen_string_literal: true

require 'test_helper'

describe Order do
  before do
    @new_order = Order.new(card_number: 1_234_567_890_123_456, card_expiration_date: Date.today + 365, card_cvv: '123',
                           address: '15 Main Street', city: 'Seattle', state: 'wa', zip_code: '98010', guest_name: 'Tyron Jenkins', email: 'tyrone@gmail.com', phone_num: '(456)123-1234', cart_status: false)

    @product_1 = products(:product_1)
    @new_product1 = Product.create(name: @product_1.name, price: @product_1.price, inventory: @product_1.inventory)

    @order1 = orders(:order1)

    @new_order_item = OrderItem.create(product: @new_product, order: @new_order)
  end

  describe 'relations' do
    it 'has many order items' do
      expect(@new_order).must_respond_to :order_items
    end
    it 'has many products' do
      expect(@new_order).must_respond_to :products
    end
  end

  describe 'validations' do
    it 'is valid when parameters are present' do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.guest_name).must_equal @order1.guest_name
    end

    it 'is invalid without a card number' do
      expect(@new_order.valid?).must_equal true # check order valid
      expect(@new_order.card_number.length).must_equal 16
      @new_order.update(card_number: nil) # make sure number nil
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid card number' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_number: 1234)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a card expiration date' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_expiration_date: nil)
      assert_nil(@new_order.card_expiration_date)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a card cvv' do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.card_cvv.length).must_equal 3
      @new_order.update(card_cvv: nil)
      assert_nil(@new_order.card_cvv)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid cvv' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_cvv: 1234)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without an address' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(address: nil)
      assert_nil(@new_order.address)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a city' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(city: nil)
      assert_nil(@new_order.city)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a state' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(city: nil)
      assert_nil(@new_order.city)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a zip code' do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.zip_code.length).must_equal 5
      @new_order.update(zip_code: nil)
      assert_nil(@new_order.zip_code)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid zip code' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(zip_code: 1234)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a guest name' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(guest_name: nil)
      assert_nil(@new_order.guest_name)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without an email' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: nil)
      assert_nil(@new_order.email)
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid with an invalid email' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: '1234 @ gmail com')
      expect(@new_order.valid?).must_equal false
    end

    it 'is invalid without a phone number' do
      expect(@new_order.valid?).must_equal true
      @new_order.update(phone_num: nil)
      assert_nil(@new_order.phone_num)
      expect(@new_order.valid?).must_equal false
    end

    # it 'is invalid with an invalid phone number' do
    #   expect(@new_order.valid?).must_equal true
    #   @new_order.update(phone_num: '123.234.1234')
    #   expect(@new_order.valid?).must_equal false
    # end
  end

  describe 'total price' do
    it 'calculates the order total correctly' do
      expect(orders(:order3).total_price).must_be_close_to 18.99
    end

    it 'returns 0.0 if the order has no items' do
      empty_order = Order.new
      expect(empty_order.total_price).must_equal 0.0
    end
  end

  describe 'purchase changes' do
    it 'flips cart status to inactive' do
      new_order = Order.create

      new_order.purchase_changes

      expect(new_order.cart_status).must_equal false
    end
  end

  describe 'cart item count' do
    before do
      @session = {} # imitate session
      @session[:order_id] = nil
    end

    it 'returns the number of items in cart' do
      new_order = orders(:order3)
      @session[:order_id] = new_order.id

      expect(Order.cart_item_count(@session)).must_equal 2
    end

    it 'returns 0 if no cart has been made' do
      expect(Order.cart_item_count(@session)).must_equal '0'
    end
  end
end
