require 'test_helper'

describe OrderItemsController do
  before do
    @merchant = merchants(:merchant_1)
    @test_product1 = products(:product_1)
    @test_product2 = products(:product_2)
    @new_order = orders(:order1)
    @new_order1 = orders(:order2)
    @new_order_item = order_items(:order_item1)
  end

  let (:new_item_hash) {
    {
      order_item: {
        name: @test_product1.name,
        price: @test_product1.price,
        quantity: 1,
        product_id: @test_product1.id
      }
    }
  }
  
  describe "index" do
    it "can get the index path" do
      get order_items_path
      must_respond_with :success
    end

    it "lists order items based on product id via nested routes" do
      get product_order_items_path(@test_product1.id)
      must_respond_with :success
      body = JSON.parse(response.body)
      expect(body.length).must_equal 2
      expect(body[0]["name"]).must_equal @test_product1.name
    end
  end

  describe "create" do
    it "can create a new OrderItem with valid information accurately, and redirect" do
      expect {
        post product_order_items_path(@test_product1.id), params: new_item_hash
      }.must_change "Product.find(#{@test_product1.id}).order_items.count", 2
      
      found_order_item = OrderItem.find_by(order_id: session[:order_id])

      expect(found_order_item.name).must_equal new_item_hash[:order_item][:name]
      expect(found_order_item.price).must_equal new_item_hash[:order_item][:price]
      expect(found_order_item.quantity).must_equal new_item_hash[:order_item][:quantity]
      expect(found_order_item.product_id).must_equal new_item_hash[:order_item][:product_id]
      expect(found_order_item.order_id).must_equal session[:order_id]

      must_redirect_to cart_path

      expect {
        post product_order_items_path(@test_product2.id), params: new_item_hash
      }.must_change "Product.find(#{@test_product2.id}).order_items.count", 3

      expect(found_order_item.order.id).must_equal session[:order_id]
      must_redirect_to cart_path
    end

    it "does not create a new OrderItem if the form data violates inventory, and responds with a redirect" do
      new_item_hash[:order_item][:quantity] = 1000
      
      expect {
        post product_order_items_path(@test_product1.id), params: new_item_hash
      }.wont_change 'OrderItem.count'

      must_redirect_to root_path
    end
  end

  describe "update" do
    let (:update_hash) {
      {
        order_item: {
          quantity: 3,
        }
      }
    }

    it "can update an existing order item, creates a flash, then redirects" do
      expect {
        patch order_item_path(@new_order_item.id), params: update_hash
      }.wont_change "OrderItem.count"

      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "does not update if there is not enough inventory" do
      update_hash[:order_item][:quantity] = 1000000

      expect {
        patch order_item_path(@new_order_item.id), params: update_hash
      }.wont_change "OrderItem.count"

      expect(flash[:failure]).must_equal 'Not enough inventory to update quantity.'
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "renders 404 not_found, does not update in the DB for nil input" do
      expect {
        patch order_item_path(-1), params: update_hash
      }.wont_change "OrderItem.count"

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "destroys an existing order item, creates a flash, then redirects" do
      expect{
        delete order_item_path(@new_order_item.id)
      }.must_change "OrderItem.count", -1

      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "renders 404 not_found, does not destroy in the DB for invalid order item" do
      expect {
        delete order_item_path(-1)
      }.wont_change "OrderItem.count"

      must_respond_with :not_found
    end
  end

end
