require "test_helper"

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

  describe "managing products" do

    describe "with correct merchant logged in" do
      it "should get new product form" do
      end

      it "should create product" do
      end

      it "should get edit product form" do
      end

      it "should respond with success when updating a product" do
      end

      it "should respond with success when deactivating a product" do
      end

    end

    describe "with incorrect merchant logged in" do
      it "should not let merchants edit products they don't own" do
      end

      it "should not update a product the merchant does not own" do
      end

      it "should not deactivate a product the merchant does not own" do
      end
    end

    describe "with no merchant logged in" do
      it "should fail to get new product form" do
      end

      it "should not create new product" do
      end

      it "should not edit a product" do
      end

      it "should not deactivate a product" do
      end
    end

  end

  # it "should get new" do
  #   get new_product_url
  #   must_respond_with :success
  # end

  # it "should create product" do
  #   assert_difference("Product.count") do
  #     post products_url, params: { product: {  } }
  #   end

  #   must_redirect_to product_url(Product.last)
  # end

  

  # it "should get edit" do
  #   get edit_product_url(@product)
  #   must_respond_with :success
  # end

  # it "should update product" do
  #   patch product_url(@product), params: { product: {  } }
  #   must_redirect_to product_url(product)
  # end

  # it "should destroy product" do
  #   assert_difference("Product.count", -1) do
  #     delete product_url(@product)
  #   end

  #   must_redirect_to products_url
  # end
end
