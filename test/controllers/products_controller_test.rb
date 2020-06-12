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
      active: true,
      category_ids: []
    )
  end

  describe "new" do 
    it "responds with success" do 
      get new_product_path 
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new product with valid information, and redirect" do 
      merchant = perform_login(merchants(:merchant1))
      product_hash = {
        product: {
          title: "kiwi",
          price: 2.99,
          description: "yellow banana",
          photo_url: "url info",
          merchant_id: merchant.id,
          stock: 5,
          category_ids: []
        }
      }
      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 1

      

      new_product = Product.find_by(title: product_hash[:product][:title])
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
end
