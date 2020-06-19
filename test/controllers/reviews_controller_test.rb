require "test_helper"

describe ReviewsController do

  let(:product_id) { products(:product1).id }
  let(:review_data) {
    {
      review: {
        rating: 3,
        description: "A good product but too expensive."
      }
    }
  }

  describe "Guest users" do
    describe "create" do
      it "can create a new reveiw with valid information accurately, and redirect" do
        url = product_reviews_path(product_id)
        expect {
          post url, params: review_data
        }.must_differ 'Review.count', 1
        saved_review = Review.last
        must_redirect_to product_path(product_id)
        expect(saved_review.rating).must_equal review_data[:review][:rating]
        expect(saved_review.description).must_equal review_data.dig(:review, :description)
      end
  
      it "does not create a review if the form data violates review validations with no rating, and responds with bad_request" do
        review_data[:review][:rating] = nil
        expect {
          post product_reviews_path(product_id), params: review_data
        }.must_differ "Review.count", 0
        must_respond_with :redirect
      end
    end
  end

  describe "logged in merchant" do
    describe "create" do
  
      it "can create a new reveiw for other merchant products" do
        perform_login(merchants(:merchant2))
        url = product_reviews_path(product_id)
  
        expect {
          post url, params: review_data
        }.must_differ 'Review.count', 1
        
        saved_review = Review.last
        must_redirect_to product_path(product_id)
        expect(saved_review.rating).must_equal review_data[:review][:rating]
        expect(saved_review.description).must_equal review_data.dig(:review, :description)
      end
  
      it "can not create a review for their own product" do
        perform_login(merchants(:merchant1))
        url = product_reviews_path(product_id)
        expect {
          post url, params: review_data
        }.wont_differ 'Review.count'
        
        must_respond_with :redirect
      end
    end
  end

end
