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
