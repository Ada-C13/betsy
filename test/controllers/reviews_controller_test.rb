require "test_helper"

describe ReviewsController do
  before do
    # We need to have a product in session in order to create a review
    @product = products(:apple)
    get product_path(@product.id)
  end
  describe "new" do 
    it "responds with success" do
      get new_review_path
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new review with valid information, and redirect" do 
      review_hash = {
        review: {
          text: "Great product!",
          rating: 5
        }
      }
      expect {
        post reviews_path, params: review_hash
      }.must_differ "Review.count", 1

      new_review = Review.last
      expect(new_review.text).must_equal review_hash[:review][:text]
      expect(new_review.rating).must_equal review_hash[:review][:rating]

      must_respond_with :redirect 
      must_redirect_to product_path(new_review.product.id)
    end

    it "does not create a new review if the form data violates Review validations" do 
      review_hash = {
        review: {
          text: ""
        }
      }

      expect {
        post reviews_path, params: review_hash
      }.must_differ "Review.count", 0
    end
  end
end
