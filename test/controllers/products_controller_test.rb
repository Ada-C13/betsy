require "test_helper"

describe ProductsController do

  describe "new" do 
    it "responds with success" do 
      get new_product_path 
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new product with valid information, and redirect" do 
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
  end

  describe "update" do 
  end
end
