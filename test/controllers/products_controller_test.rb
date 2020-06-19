require "test_helper"

describe ProductsController do
  let (:merchant_1) {
    merchants(:merchant_1)
  }    

  let (:product_1) {
    products(:product_1)
  }

  let (:product_2) {
    products(:product_2)
  }

  let (:inactive_product) {
    products(:product_3)
  }

  let (:product_hash) {
    {
      product: {
        name: "Monstera",
        price: 39.99,
        description: "Big green plant!",
        inventory: 3,
        status: true,
        photo_url: "https://bloomscape.com/wp-content/uploads/2019/11/bloomscape_peopleplants_monstera-scaled.jpg"
      }
    }
  }

  describe "index" do
    it "must get index" do
      get products_path
      must_respond_with :success
    end

  end

  describe "new" do
    it "gets the path" do
      perform_login()
      get new_product_path
      must_respond_with :success
    end

    it "if not logged in, redirects to root path" do
      get new_product_path
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end


  describe "create" do
    describe "logged in" do
      before do
        perform_login()
      end

      it "creates a new product" do
        new_product = {
          product: {
            name: "A Really Big Monstera",
            price: 39.99,
            description: "Big green plant!",
            inventory: 3,
            status: true,
            photo_url: "https://bloomscape.com/wp-content/uploads/2019/11/bloomscape_peopleplants_monstera-scaled.jpg"
          }
        }

        expect {
          post products_path, params: new_product
        }.must_differ 'Product.count', 1

        must_respond_with :redirect
        must_redirect_to product_path(Product.last.id)
        expect(Product.last.name).must_equal new_product[:product][:name]
        expect(Product.last.price).must_equal new_product[:product][:price]
        expect(Product.last.description).must_equal new_product[:product][:description]
        expect(Product.last.inventory).must_equal new_product[:product][:inventory]
      end

      it "doesn't create a product with invalid data" do
        product_hash[:product][:name] = nil

        expect {
          post products_path, params: product_hash
        }.must_differ "Product.count", 0

        must_respond_with :bad_request
      end
    end

    it "if user is not logged in, redirects to homepage" do       
      expect{ post products_path, params: product_hash }.must_differ 'Product.count', 0
      
      must_respond_with :redirect
      must_redirect_to root_path
    end    
  end

  describe "show" do
    it "will get show for valid ids" do
      # Arrange
      valid_product_id = product_1.id
  
      # Act
      get product_path(valid_product_id)
  
      # Assert
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      # Arrange
      invalid_product_id = 999
  
      # Act
      get product_path(invalid_product_id)
  
      # Assert
      must_respond_with :not_found
    end

    it "cannot view product with status set to false if not logged in" do
      get product_path(246273452735)
          
      # Assert
      must_respond_with :not_found
    end
  end

  describe "edit" do

    describe "logged in" do
      before do
        perform_login()
      end

      it "can access the edit product page if logged in creator" do
        get edit_product_path(product_1)

        must_respond_with :success
        expect(flash[:success]).wont_be_nil
      end
    
      it "will respond with not_found for invalid ids" do
        id = -1
    
        expect {
          get edit_product_path(id), params: product_hash
        }.wont_change "Product.count"
    
        must_respond_with :not_found
      end
    
      it "can't edit another merchant's product" do
        id = product_2.id

        get edit_product_path(id)
    
        must_respond_with :redirect
        must_redirect_to product_path(id) 
    
        expect(flash[:error]).wont_be_nil
      end
    end

    it "can't edit a product if not logged in" do
      id = product_2.id

      get edit_product_path(id)
  
      must_respond_with :redirect
      must_redirect_to root_path
  
      expect(flash[:error]).wont_be_nil
    end
  end

  describe "update" do

    describe "logged in" do
      before do
        perform_login()
      end

      it "will update a product with a valid post request and redirect" do
        id = Product.first.id
        expect {
          patch product_path(id), params: product_hash
        }.wont_change "Product.count"
    
        must_respond_with :redirect
        must_redirect_to product_path(id)
    
        product = Product.find_by(id: id)
        expect(product.name).must_equal product_hash[:product][:name]
        expect(product.description).must_equal product_hash[:product][:description]
      end
    
      it "will respond with not_found for invalid ids" do
        id = -1
    
        expect {
          patch product_path(id), params: product_hash
        }.wont_change "Product.count"
    
        must_respond_with :not_found
      end
    
      it "will not update if the params are invalid" do
        product_hash[:product][:name] = nil

        expect {
          patch product_path(product_1.id), params: product_hash
        }.wont_change "Product.count"

        product_1.reload # refresh the product from the database
        must_respond_with :bad_request
        expect(product_1.name).wont_be_nil
      end
    end

    it "will not change a product if not logged in" do
      id = Product.first.id
      name = Product.first.name
      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"
  
      must_respond_with :redirect
      must_redirect_to root_path
  
      product = Product.find_by(id: id)
      expect(product.name).must_equal name
    end
  end
end
