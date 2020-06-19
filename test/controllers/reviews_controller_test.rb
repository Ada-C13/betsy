require "test_helper"

describe ReviewsController do
  describe "new" do
    it "responds with success for valid product" do
      product = products(:product_1)

      get new_product_review_path(product.id)
      
      must_respond_with :success
    end

    it "responds with not_found for invalid product" do
      get new_product_review_path(-1)
      
      must_respond_with :not_found
    end

    it "flashes error message and redirects if merchant tries to review their own product" do
      perform_login(merchants(:merchant_1))
      product = products(:product_1)

      get new_product_review_path(product.id)
      
      expect(flash[:error]).must_equal "You cannot review your own products"
      must_redirect_to product_path(product.id)
    end

  end

  describe "create" do
    it "can create a new review with valid information and redirect" do
      product = products(:product_1)
    
      # Arrange
      review_hash = {
        review: {
          rating: 4,
          description: "it's great",
          product: product
        },
      }
      
      # Act-Assert
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_change "Review.count", 1
      
      new_review = Review.find_by(description: review_hash[:review][:description])
      expect(new_review.description).must_equal review_hash[:review][:description]
      expect(new_review.rating).must_equal review_hash[:review][:rating]
      expect(new_review.product).must_equal review_hash[:review][:product]
      expect(flash[:success]).must_include "Thank you for reviewing"

      must_redirect_to product_path(product.id)
    end

    it "does not create a review if invalid rating is provided" do
      product = products(:product_1)
    
      # Arrange
      review_hash = {
        review: {
          rating: 0,
          description: "it's great",
          product: product
        },
      }
      
      # Act-Assert
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.wont_change "Review.count"
      
      expect(flash[:error]).must_include "A problem occurred: Could not create review"
    end

    it "does not create a review if the signed in user is the merchant associated with the product" do
      perform_login
      product = products(:product_1)
    
      review_hash = {
        review: {
          rating: 4,
          description: "it's great",
          product: product
        },
      }
      
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_change "Review.count", 0
    end

    it "does not create a review if the product does not exist" do
      expect {
        post product_reviews_path(-1)
      }.must_differ "Review.count", 0
            
      must_respond_with :not_found
    end
  end
end
