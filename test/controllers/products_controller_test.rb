require "test_helper"
require "json"

describe ProductsController do
  let(:product) { products(:daisy) }

  it "should get index" do
    get products_url
    must_respond_with :success
  end

  it "should show product" do
    get product_url(product)
    must_respond_with :success
  end

  describe 'filtering products' do
    let(:vegetable) { categories(:vegetable) }
    let(:flower) { categories(:flower) }
    let(:herb) { categories(:herb) }
    let(:annie) { merchants(:annie) }

    it "can filter products by categories and merchants" do
      get products_url, params: {categories: [vegetable.id, flower.id], merchants: [annie.id]}
      must_respond_with :success
      products = @controller.instance_variable_get(:@products)

      expect(products.count).must_equal 4
      expect(products).must_include products(:daisy)
      expect(products).must_include products(:tulip)
      expect(products).must_include products(:onion)
      expect(products).must_include products(:mint)

      expect(products).wont_include merchants(:angela)
      expect(products).wont_include products(:cilantro)
    end

    it "can show only active products" do
      get products_url, params: {categories: [vegetable.id, herb.id], merchants: [annie.id]}
      must_respond_with :success
      products = @controller.instance_variable_get(:@products)

      expect(products.count).must_equal 2
      expect(products).must_include products(:onion)
      expect(products).must_include products(:mint)

      expect(products).wont_include products(:tulip)
      expect(products).wont_include merchants(:angela)
      expect(products).wont_include products(:cilantro)
    end
  end

  describe "managing products" do

    let(:new_product) {
      {
        name: "Something Shiny New",
        stock: 2,
        price: 5,
      }
    }

    describe "with correct merchant logged in" do

      before do
        perform_login
        @current_merchant = session[:merchant_id]
      end

      it "should get new product form" do
        get new_product_url
        must_respond_with :success
      end

      it "should create product and redirect to its product page" do
        assert_difference("Product.count") do
          post products_url, params: { product: new_product }
        end
        latest_product = Product.last
        must_redirect_to product_url(latest_product)
        expect(flash[:success]).must_equal "Successfully created #{latest_product.name}"
        expect(latest_product.merchant.id).must_equal session[:merchant_id]
      end

      it "should get edit product form" do
        post products_url, params: { product: new_product }
        get edit_product_url(Product.last.id)
        must_respond_with :success
      end

      it "should redirect to product and flash success on valid update" do
        post products_url, params: { product: new_product }
        latest_product = Product.last
        patch product_url(latest_product), params: { product: { name: "Updated Name" } }
        must_redirect_to latest_product
        expect(flash[:success]).must_equal "Successfully updated product."
      end

      it "should respond with bad request on invalid update attempt" do
        post products_url, params: { product: new_product }
        updated_product = Product.last
        updated_product.name = nil
        updated_product.stock = -1
        patch product_url(updated_product), params: { product: { name: updated_product.name, stock: updated_product.stock } }
        must_respond_with :bad_request
        updated_product.valid?
        expect(updated_product.errors.messages[:name]).must_equal ["can't be blank"]
        expect(updated_product.errors.messages[:stock]).must_equal ["must be greater than 0"]
      end

      it "should change active from true to false when deactivating a product" do
        daisy = products(:daisy)
        expect( daisy.active ).must_equal true

        post product_deactivate_path(daisy)
        must_redirect_to product_path(daisy)

        daisy.reload
        expect( daisy.active ).must_equal false
      end

      it "should change active from false to true when deactivating a product" do
        daisy = products(:daisy)
        daisy.active = false
        daisy.save
        expect( daisy.active ).must_equal false

        post product_deactivate_path(daisy)
        must_redirect_to product_path(daisy)
        
        daisy.reload
        expect( daisy.active ).must_equal true
      end

      it "should respond with not found if product is not given" do
        patch product_url(-1), params: { product: new_product }
        must_respond_with :not_found
      end
    end

    describe "with incorrect merchant logged in" do

      before do
        perform_login
        @current_merchant = session[:merchant_id]
      end

      it "should not let merchants edit products they don't own" do
        get edit_product_url(Product.last.id)
        must_redirect_to dashboard_merchant_url(@current_merchant)
        expect(flash[:warning]).must_equal "Tried to access a resource that isn't yours. Returning to your dashboard."
      end

      it "should not update a product the merchant does not own" do
        patch product_url(Product.last.id), params: { product: { name: "Updated Name" } }
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Could not complete that request with invalid credentials."
      end

      it "should not deactivate a product the merchant does not own" do
        onion = products(:onion)
        expect( onion.active ).must_equal true

        post product_deactivate_path(onion)
        must_redirect_to root_path
        
        onion.reload
        expect( onion.active ).must_equal true
        expect(flash[:danger]).must_equal "Could not complete that request with invalid credentials."
      end
    end

    describe "with no merchant logged in" do

      before do
        perform_login
        perform_logout
      end

      it "should fail to get new product form" do
        get new_product_url
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end

      it "should not create new product" do
        assert_no_difference("Product.count") do
          post products_url, params: { product: new_product }
        end
        must_respond_with :bad_request
      end

      it "should not edit a product" do
        patch product_url(Product.last.id), params: { product: { name: "Updated Name" } }
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end

      it "should not deactivate a product" do
        onion = products(:onion)
        expect( onion.active ).must_equal true

        post product_deactivate_path(onion)
        must_redirect_to root_path
        
        onion.reload
        expect( onion.active ).must_equal true
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end
    end

  end

end
