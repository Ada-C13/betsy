require "test_helper"

describe ProductsController do
  before do
    @product = Product.new(
      title: "test wand",
      price: 2.99,
      photo_url: "https://i.imgur.com/6lRh94a.jpg",
      description: "best wand i've ever seen",
      stock: 2,
      merchant_id: merchants(:merchant1).id,
      active: true)
  end

  describe "new" do 
    it "responds with success" do 
      get new_product_path 
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new product with valid information, and redirect" do 
      current_merchant = perform_login(merchants(:merchant_one))

      product_hash = {
        product: {
          title: "kiwi",
          price: 2.99,
          description: "yellow banana",
          photo_url: "url info",
          stock: 5
        }
      }

      puts "PRODUCT COUNT BEFORE  = #{Product.count}"

      expect {
        post products_path, params: product_hash
        puts "PRODUCT COUNT NOW = #{Product.count}"
      }.must_differ "Product.count", 1

      new_product = Product.find_by(title: product_hash[:product][:title])
      puts "NEW PRODUCT = #{new_product}"
      expect(new_product.price).must_equal product_hash[:product][:price]
      expect(new_product.description).must_equal product_hash[:product][:description]
      expect(new_product.photo_url).must_equal product_hash[:product][:photo_url]
      expect(new_product.stock).must_equal product_hash[:product][:stock]

      must_respond_with :redirect 
      must_redirect_to product_path(new_product.id)
    end

    it "does not create a new product if the form data violates Product validations" do 
      product_hash = {
        product: {
          title: "banana"
        }
      }

      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0
    end
  end

  describe "edit" do 
    it "responds with success when getting the edit page for an existing, valid product" do
      product = products(:apple)

      get edit_product_path(product.id)

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing product" do 
      # Act
      get edit_product_path(-1)

      # Assert
      must_respond_with :redirect
      must_redirect_to products_path 
    end
  end

  describe "update" do 
    it "will update existing product" do 

      @product.save

      puts "PRODUCT BEFORE UPDATE = #{@product.price}"
      puts "PRODUCT ID BEFORE UPDATE = #{@product.id}"
      
      product_hash = {
        product: {
          price: 10,
          description: "updated apple"
        }
      }

      patch product_path(@product.id), params: product_hash

      @product.save!
      @product.reload 
      puts "PRODUCT AFTER UPDATE = #{@product.price}"

      expect(@product.price).must_equal product_hash[:product][:price]
      expect(@product.description).must_equal product_hash[:product][:description]

    end

    it "will not update any product if given an invalid id, and responds with 404" do 
      product_hash = {
        product: {
          price: 10,
          description: "updated apple"
        }
      }

      expect {
        patch product_path(-1), params: product_hash
      }.must_differ "Product.count", 0
    end
  end
  
  describe "index" do
    it "responds with success when there are no products saved" do
      # Arrange
      # Ensure that there are zero products saved
      Product.destroy_all
      products = Product.all
      expect(products.length).must_equal 0
      # Act
      get products_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there is at least 1 product saved" do
      # Arrange
      Product.destroy_all
      @product.save
      # Act
      get products_path
      # Assert
      expect(Product.all.length).must_equal 1
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid product" do
      # Arrange
      @product.save
      # Act
      get product_path(@product.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect with an invalid product id" do
      # Arrange, Act
      get product_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end


  describe "retire" do 
    it "will change the product status from active to inactive and redirect" do 
      @product.save
      expect(@product.active).must_equal true

      post retire_product_path(@product.id)

      @product.reload 

      expect(@product.active).must_equal false 
      must_respond_with :redirect
      must_redirect_to product_path(@product.id)
    end

    it "will change the product status from inactive to active and redirect" do 
      @product.active = false 
      @product.save 
      expect(@product.active).must_equal false

      post retire_product_path(@product.id)
      @product.reload 

      expect(@product.active).must_equal true
      must_respond_with :redirect
      must_redirect_to product_path(@product.id)
    end

    it "will prevent toggling other merchant's product" do 
      # Arrange
      @product.save
      expect(@product.active).must_equal true

      other_merchant = Merchant.create(
        username: "harry",
        uid: 444,
        email: "harry@gmail.com",
        provider: "github"
      )
      product = products(:banana)
      product.merchant_id = other_merchant.id 
      product.save 

      # Act
      post retire_product_path(product.id)

      # Assert
      expect(@product.active).must_equal true
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end
  end

  describe "add to cart" do
    before do 
      @product_2 = products(:apple)
    end

    let (:order_item_params) {
      {
        quantity: 1,
      }
    }

    it "can create a new order item with valid information accurately, and redirect" do
      expect {
        post add_to_cart_path(@product_2.id), params: order_item_params
      }.must_differ "OrderItem.count", 1
      
      new_order_item = OrderItem.find_by(product_id: @product_2.id)
      expect(new_order_item.order_id).must_equal session[:order_id]
      expect(new_order_item.quantity).must_equal order_item_params[:quantity]
      expect(new_order_item.shipped).must_equal false

      expect(flash[:result_text]).must_include "Successfully added #{@product_2.title} to cart!"
      
      must_redirect_to product_path(new_order_item.product_id)
    end

    it "creates a new order if there is no order_id stored in session" do
      expect {
        post add_to_cart_path(@product_2.id), params: order_item_params
      }.must_differ "Order.count", 1

      new_order = Order.last
      expect(session[:order_id]).must_equal new_order.id
    end

    it "does not create an order item if the product_id is invalid, and responds with a 404" do
      expect {
        post add_to_cart_path(-1), params: order_item_params
      }.wont_differ "OrderItem.count"

      must_respond_with :not_found
    end

    it "does not create an order item if the quantity requested is greater than the product stock" do
      invalid_order_item_params = {
        quantity: @product_2.stock + 1,
      }

      expect {
        post add_to_cart_path(@product_2.id), params: invalid_order_item_params
      }.wont_differ "OrderItem.count"

      expect(flash[:result_text]).must_include "A problem occurred: #{@product_2.title} does not have enough quantity in stock"

      must_redirect_to product_path(@product_2.id)

    end
  end
end
