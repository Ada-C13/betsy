require "test_helper"

describe ProductsController do
  describe "unauthenticated" do
    describe "index" do
      it "responds with success when there are products" do
        get products_path
        
        must_respond_with :success
      end
      
      it "responds with success when there are no products" do
        Product.destroy_all
        get products_path
        
        must_respond_with :success
      end
    end

    describe "show" do 
      it "redirects to the product detail page" do 
        product = products(:pengsoo_nose)

        get product_path(product.id)

        must_respond_with :success
      end

      it "redirects to the not found page for an invalid product id" do 
        invalid_id = -1

        get product_path(invalid_id)

        must_respond_with :not_found
      end
    end

    describe "new" do
      it "does not show the form to create new product" do
        get new_product_path
        
        expect(flash[:error]).must_include "You must be logged in to do that"
      end
    end
  end

  describe "authenticated" do
    before do
      @login_user = login(users(:user1))
    end

    describe "new" do
      it "shows form for new product" do
        get new_product_path
        
        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new product given valid information" do   
        product = {
          product: {
            name: "Apron Skirt", 
            description: "for all your cooking!",
            price: 700, 
            inventory: 3,
            photo_url: "https://villagerdb.com/images/items/full/apron-skirt.fa97145.png",
            active: true,
            user_id: @login_user.id
          }
        }
        
        expect {post products_path, params: product}.must_differ "Product.count", 1
        
        new_product = Product.last
        
        expect(new_product.name).must_equal product[:product][:name]
        expect(flash.now[:success]).must_equal "#{new_product.name} was successfully added! 😄"
        must_respond_with :redirect
        must_redirect_to product_path(new_product)
      end
      
      it "doesn't create a new product if given invalid information" do
        invalid_product = {
          product: {
            name: nil, 
            description: "for all your cooking!",
            price: 700, 
            inventory: 3,
            photo_url: "https://villagerdb.com/images/items/full/apron-skirt.fa97145.png",
            active: true
          }
        }
        
        expect {post products_path, params: invalid_product}.wont_change "Product.count"
        expect(flash.now[:error]).must_include "A problem occurred: Could not update #{invalid_product[:product][:name]}"
        expect(flash.now[:error]).must_include "can't be blank"
        assert_template :new
      end
    end

    describe "edit" do 
      it "responds with success when getting the edit page for an existing, valid product" do
        valid_product = products(:amber)

        expect(session[:user_id]).wont_be_nil
        expect(flash[:success]).must_include "Logged in as returning user"

        get edit_product_path(valid_product.id)

        must_respond_with :success
      end

      it "redirects when trying to edit other users' products" do 
        another_product = products(:shirt)
        get edit_product_path(another_product.id)

        must_redirect_to dashboard_path
      end
    end


    describe "update" do
      it "updates an existing product" do
        product_updates = {
          product: {
            name: "banana"
          }
        }
        
        valid_product = products(:amber)
        valid_product_name = valid_product.name
        
        expect(products(:amber).name).must_equal valid_product_name
        expect{
          patch product_path(valid_product.id), params: product_updates
        }.wont_change "Product.count"
        
        updated_product = Product.find_by(id: valid_product.id)
        expect(updated_product.name).must_equal product_updates[:product][:name]
        must_respond_with :redirect
      end

      it "will not update existing category whith invalid params (nil)" do
        product_updates = {
          product: {
            name: nil
          }
        }

        og_product = products(:amber)

        expect {
          patch product_path(products(:amber).id), params: product_updates
        }.wont_change "Product.count"

        expect(flash.now[:error]).must_include "The product was not successfully edited"
        must_respond_with :bad_request
        assert_template :edit
      end
    
      it "will not update existing category whith invalid params (empty)" do
        product_updates = {
          product: {
            name: nil
          }
        }

        og_product = products(:amber)
        
        expect {
          patch product_path(products(:amber).id), params: product_updates
        }.wont_change "Product.count"

        expect(flash.now[:error]).must_include "The product was not successfully edited"
        assert_template :edit
      end
    end

    describe "toggle_status" do
      it "can activate a product" do 
        product = products(:cat_nose)
        expect(product.active).must_equal false 
        patch toggle_status_path(product.id)
        expect(Product.find_by(id: product.id).active).must_equal true
      end

      it "can inactivate a product" do 
        product = products(:dog_nose)
        expect(product.active).must_equal true
        patch toggle_status_path(product.id)
        expect(Product.find_by(id: product.id).active).must_equal false
      end      
    end

    describe "search" do 
      it "can search product" do 
        search_params = {
          "search": "bottom"
        }

        get search_path, params: search_params

        expect(flash[:error]).must_be_nil
        must_respond_with :success

      end

      it "wont search anything if an empty string is given" do 
        search_params = {
          "search": ""
        }

        get search_path, params: search_params

        expect(flash[:error]).must_equal "Empty field!"
        must_redirect_to frontpage_path
      end
    end
  end
end
