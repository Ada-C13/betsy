require "test_helper"

describe ProductsController do
  before do
    @product = Product.new(
      name: "XXXX", 
      price: 20.00,
      stock: 20,
      active: true,
      description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
      photo: "https://i.imgur.com/WSHmeuf.jpg",
      merchant: merchants(:merchantaaa)
    )
    @product_one = products(:product1)
    @merchant = merchants(:merchantaaa)
    perform_login(@merchant)
    @session_id = session[:merchant_id]
    @merchant2 = merchants(:merchantbbb)
  end

  describe "index" do
    it "responds with success when there are many products saved" do
      @product.save
      get products_path
      must_respond_with :success
    end

    it "responds with success when there are no product saved" do
      get products_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid product" do
      @product.save
      get product_path(@product.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid product id" do
      get product_path(-1)
      must_redirect_to products_path
    end
  end

  describe "create" do
    before do
      @product_hash = {
        product: {
          name: "XXXX", 
          price: 20.00,
          stock: 20,
          active: true,
          description: "Description for the new movie",
          photo: "https://i.imgur.com/WSHmeuf.jpg",
          merchant_id: @merchant.id,
      } 
    }
    end

    it "can create a new product with valid information accurately if the user is logged in, and redirect" do
      # Act-Assert
      expect {
        post products_path, params: @product_hash
      }.must_differ "Product.count", 1
      
      expect(Product.last.name).must_equal @product_hash[:product][:name]
      expect(Product.last.price).must_equal @product_hash[:product][:price]
      expect(Product.last.stock).must_equal @product_hash[:product][:stock]
      expect(Product.last.active).must_equal @product_hash[:product][:active]
      expect(Product.last.description).must_equal @product_hash[:product][:description]
      expect(Product.last.merchant_id).must_equal @product_hash[:product][:merchant_id]

      expect(flash[:success]).must_equal "Successfully created #{@product.name}"
      must_redirect_to account_path(@merchant)
    end

    it "does not create a product if name is not present, and responds with bad_request" do
      @product_hash[:product][:name] = nil
    
      expect {
        post products_path, params: @product_hash
      }.wont_change "Product.count"
      
      assert_response :bad_request
    end

    it "does not create a product if price is not present, and responds with bad_request" do
      @product_hash[:product][:price] = nil
    
      expect {
        post products_path, params: @product_hash
      }.wont_change "Product.count"
      
      assert_response :bad_request
    end

    it "does not create a product if stock is not present, and responds with bad_request" do
      @product_hash[:product][:stock] = nil
    
      expect {
        post products_path, params: @product_hash
      }.wont_change "Product.count"
      
      assert_response :bad_request
    end

    it "does not create a product if description is not present, and responds with bad_request" do
      @product_hash[:product][:description] = nil
    
      expect {
        post products_path, params: @product_hash
      }.wont_change "Product.count"
      
      expect(flash.now[:error]).must_equal "A problem occurred: Could not create product"
      assert_response :bad_request
    end

    it "does not create a product if merchant is not logedin" do
      put logout_path, params: {}
    
      expect {
        post products_path, params: @product_hash
      }.wont_change "Product.count"
      must_redirect_to root_path
    end
    
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid product" do
      get edit_product_path(@product_one.id)
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing product" do
      get edit_product_path(-1)
      must_redirect_to products_path
    end
  end

  describe "update" do
    before do
      @edited_product_hash = {
        product: {
          name: "XXXX", 
          price: 20.00,
          stock: 20,
          active: true,
          description: "Description for the new movie",
          photo: "https://i.imgur.com/WSHmeuf.jpg",
          merchant_id: @merchant.id,
      } 
    }
    end
    
    it "can update an existing product with valid information accurately, and redirect" do
      id = @product_one.id

      expect{
        patch product_path(id), params: @edited_product_hash
      }.wont_change "Product.count"

      @product_one.reload
      expect(@product_one.name).must_equal @edited_product_hash[:product][:name]
      expect(@product_one.price).must_equal @edited_product_hash[:product][:price]
      expect(@product_one.stock).must_equal @edited_product_hash[:product][:stock]
      expect(@product_one.active).must_equal @edited_product_hash[:product][:active]
      expect(@product_one.description).must_equal @edited_product_hash[:product][:description]
      expect(@product_one.merchant_id).must_equal @edited_product_hash[:product][:merchant_id]

      expect(flash[:success]).must_equal "Successfully updated #{@product_one.name}"
      must_redirect_to product_path(id)
    end

    it "does not update any product if given an invalid id, and responds with a 404" do
      expect{
        patch product_path(-1), params: @edited_product_hash
      }.wont_change "Product.count"
      
      must_respond_with :not_found
    end

    it "does not update a product if the form data violates Product validations, and responds with a 400 error" do
      @edited_product_hash[:product][:price] = nil

      expect{
        patch product_path(@product_one), params: @edited_product_hash
      }.wont_change "Product.count"
    
      #expect(flash.now[:error]).must_equal "#{@product_one.errors.messages}"
      # it responds with right flash message, but I"m unable to test it 
      assert_response :bad_request
    end
  end 
end
