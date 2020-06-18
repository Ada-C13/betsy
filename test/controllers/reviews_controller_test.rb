require "test_helper"

describe ReviewsController do
  let(:product) { products(:daisy) }

  describe "new" do
    it "can get the review_path" do
      get new_product_review_path(product)
      must_respond_with :success
    end

    it "can't review own product" do
      perform_login(product.merchant)

      get new_product_review_path(product) # /products/{product.id}/reviews/new
      expect(flash[:warning]).must_equal "You can't review your own product!"
      must_redirect_to product_path(product)
    end
  end

  describe "create new review" do
    it "should create new review" do
      assert_difference("Review.count") do
        post product_reviews_path(product), params: { review: { rating: 5, comment: "I was happy with my daisies!", product_id: product.id } }
      end

      must_redirect_to product_path(product)
    end

    it "can't create with out rating" do
      assert_no_difference("Review.count") do
        post product_reviews_path(product), params: { review: { rating: nil, comment: "I wasn't happy with my daisies!", product_id: product.id } }
      end

      must_respond_with :bad_request
    end

    it "can't create with rating that is above 5" do
      assert_no_difference("Review.count") do
        post product_reviews_path(product), params: { review: { rating: 8, comment: "I was really happy with my daisies!", product_id: product.id } }
      end

      must_respond_with :bad_request
    end

    it "should redirect to products_path" do
    
      get new_product_review_path(1000)
      expect(flash[:warning]).must_equal "Product not found!"
      must_redirect_to products_path
    end
  end
end
