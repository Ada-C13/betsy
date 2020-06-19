require "test_helper"

describe OrdersController do
  before do
    @product = products(:leash)
    @new_order_hash =
      {
        order: {
          email_address: "louie@hotmail.com",
          mailing_address: "52 Center St.",
          name_on_credit_card: "Louie",
          credit_card_number: "4321432143214321",
          credit_card_expiration: "03/22",
          credit_card_CVV: "321",
          billing_zip_code: "12321"
        },
      }
  end

  describe "show" do
    it "will get show for valid ids" do
      original_order_count = Order.count
      order = create_order(@product,1)
      expect(Order.count).must_equal original_order_count + 1

      session[:order_id].must_equal order.id

      get order_path(order.id)

      must_respond_with :success
    end

    it "will respond with not_found if no current order set" do
      assert_raises( "NoMethodError") { get order_path(-1) }
    end
  end

  describe "update" do

    it "will update a model with a valid post request" do
      @order = create_order(@product,1)

      expect {
        patch order_path(@order.id), params: @new_order_hash
      }.wont_change "Order.count"
  
      must_redirect_to finalize_order_path
  
      order = Order.find_by(id: @order.id)
      expect(order.email_address).must_equal @new_order_hash[:order][:email_address]
      expect(order.mailing_address).must_equal @new_order_hash[:order][:mailing_address]
      expect(order.name_on_credit_card).must_equal @new_order_hash[:order][:name_on_credit_card]
      expect(order.credit_card_number).must_equal @new_order_hash[:order][:credit_card_number]
      expect(order.credit_card_expiration).must_equal @new_order_hash[:order][:credit_card_expiration]
      expect(order.credit_card_CVV).must_equal @new_order_hash[:order][:credit_card_CVV]
      expect(order.billing_zip_code).must_equal @new_order_hash[:order][:billing_zip_code]

    end
  
    it "will redirect to root path if no current order is" do
  
      expect {
        patch order_path(-1), params: @new_order_hash
      }.wont_change "Order.count"
  
      must_redirect_to root_path
    end
  
    it "will not update if the params are invalid" do
      @order = create_order(@product,1)
      @new_order_hash[:order][:credit_card_number] = nil

      expect {
        patch order_path(@order), params: @new_order_hash
      }.wont_change "Order.count"
  
      must_redirect_to edit_order_path(@order.id)
    end
  end

  describe "cancel order" do

    it "will change order status to cancelled and clear session order id" do
      order_id = create_order(@product,1).id
      patch order_path(order_id), params: @new_order_hash

      patch cancel_order_path(order_id)

      reloaded_order = Order.find_by(id:order_id)
      expect(reloaded_order.order_status).must_equal "cancelled"

      session[:order_id].must_equal nil
      must_redirect_to root_path
    end

  end

  describe "finalize_order" do

    it "will successfully show finalize page" do
      order_id = create_order(@product,1).id
      patch order_path(order_id), params: @new_order_hash

      get finalize_order_path(order_id)
    end

    it "will redirect to root path if current order doesn't exist" do
      get finalize_order_path(1)
      must_redirect_to root_path
      flash[:error].must_equal "Order does not exist"
    end

    it "will redirect to root path if current order is not equal to order id in params" do
      order_id = create_order(@product,1).id
      patch order_path(order_id), params: @new_order_hash

      get finalize_order_path(-1)
      must_redirect_to root_path
      flash[:error].must_equal "You can't finalize an order that isn't yours"
    end
  end

  describe "edit order" do

    it "will successfully show edit page if current order exists" do
      order_id = create_order(@product,1).id
      patch order_path(order_id), params: @new_order_hash

      get edit_order_path(order_id)
    end

    it "will redirect to root path if current order doesn't exist" do
      get edit_order_path(1)
      must_redirect_to root_path
      flash[:error].must_equal "Order does not exist"
    end

    it "will redirect to root path if current order is not equal to order id in params" do
      order_id = create_order(@product,1).id
      patch order_path(order_id), params: @new_order_hash

      get edit_order_path(-1)
      must_redirect_to root_path
      flash[:error].must_equal "You can't edit an order that isn't yours"
    end
  end


  describe "place order" do

    before do
      @order = create_order(@product,1)
      patch order_path(@order), params: @new_order_hash
    end

    it "will successfully place order if current order exist and are in stock and clear session" do
      patch place_order_path(@order)
      @order = Order.find_by(id: @order.id)
      expect(@order.order_status).must_equal "paid"
      expect( session[:order_id]).must_equal nil

    end

    it "will not successfully place order if current order exists but item is not in stock" do
      product_to_change = @product
      product_to_change.stock = 0
      product_to_change.save
      # binding.pry
      patch place_order_path(@order)

      @order = Order.find_by(id: @order.id)
      expect(@order.order_status).must_equal "pending"
      expect( session[:order_id]).must_equal @order.id
    end


  end
  describe "confirmation" do

    it "will successfully show edit page if current order exists" do
      order = Order.first
      get confirm_order_path(order)
    end


  end


end
