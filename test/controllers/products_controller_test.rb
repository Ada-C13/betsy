require "test_helper"

describe ProductsController do
  before do
    @invalid_product_id = -1
    @valid_product_id = products(:snow_pass).id
  end

  describe "index" do
    it "responds with success when there are many products saved" do
      Product.create(product_name: 'Smartwool Socks', price: 20.00)
      Product.create(product_name: 'Cliff Coffee Bar', price: 2.00)

      get products_path

      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      get products_path

      must_respond_with :success
    end
  end


  describe "show" do
    it "responds with success when showing an existing valid product" do
      # TODO
      products(:snow_pass).merchant = merchants(:diana)
      products(:snow_pass).save

      get product_path(@valid_product_id)

      must_respond_with :success
    end

    it "responds with 404 with an invalid product id" do
      get product_path(@invalid_product_id)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path

      must_redirect_to root_path
    end
  end

  describe "create" do
    let (:product_hash) {
      {
        product: {
          product_name: "Mt. Everest",
          description: "Yeah that mountain",
          price: 300000,
          photo_url: "www.learningtoliketests.com/sort-of.png",
          stock: 3,
          retired: false,
          merchant_id: merchants(:diana).id
        }
      }
    }

    it "can create a new product, and responds with a redirect" do
      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      must_redirect_to product_path(Product.last)
      expect(Product.last.product_name).must_equal product_hash[:product][:product_name]
    end

    it "does not create a product if given bad/insufficient data, and responds with a redirect" do
      invalid_product_hash = product_hash[:product][:merchant_id] = nil

      expect {
        post products_path, params: invalid_product_hash
      }.must_differ 'Product.count', 0

      must_respond_with  :redirect
      must_redirect_to new_product_path
    end
  end

  describe "update" do
    let(:update_hash) {
      {
        product: {
        merchant_id: merchants(:diana).id
        }
      }
    }
    
    it "can update an existing product with valid info and redirect" do
      expect { 
        patch product_path(@valid_product_id), params: update_hash
      }.wont_change Product.count
      
      updated_item = products(:snow_pass).reload
      must_redirect_to product_path(products(:snow_pass))
      expect(updated_item.merchant_id).must_equal update_hash[:product][:merchant_id]
    end

    it "does not update product when given bad data" do
      update_hash[:product][:merchant_id] = nil

      expect {
        patch product_path(@valid_product_id), params: update_hash
      }.wont_change Product.count

      expect {
        patch product_path(@valid_product_id), params: update_hash
      }.wont_change products(:snow_pass).merchant_id
    end
  end

  describe "edit" do
    it "prevents editing a product and flashes the correct message when not logged in" do
      get edit_product_path(@valid_product_id)
      assert_equal 'A problem occurred: You must log in to do that', flash[:error]
    end

    # TODO: testing out login functionality
    it "redirects if the user editing a product's merchant is not the merchant" do
      perform_login
      @current_user = 1
      get edit_product_path(@valid_product_id)

      assert_equal 'You cannot edit a product that you do not sell', flash[:error]
    end

    it "responds with success when getting the edit page for an existing, valid product" do
      get edit_product_path(@valid_product_id)

      must_redirect_to root_path
    end

    it "responds with redirect when getting the edit page for a non-existing product" do
      get edit_product_path(@invalid_product_id)

      must_respond_with :not_found
    end
  end

  describe "retired" do
    # TODO: Login permissions
    # it "marks a product as retired" do
      
    #   expect {
    #     patch patch retired_product_path(@valid_product_id)
    #   }.wont_change Product.count

    #   products(:snow_pass).retired.must_equal true
    # end
  end
end
