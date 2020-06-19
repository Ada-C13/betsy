require "test_helper"

describe ReviewsController do
  before do
    @merchant = merchants(:merchant_1)
    @product = products(:product_1)
  end

  let (:create_review) {
    {
      review: {
        title: 'So Good',
        rating: 5,
        description: 'How did I get such a perfect plant',
        merchant_id: merchants(:merchant_1).id
      },
    }
  }
  describe "create" do

    it "leaves a review when not logging in" do
      expect {
        post product_reviews_path(product_id: @product.id), params: create_review 
      }.must_change 'Review.count', 1

      new_review = Review.find_by(product_id: @product.id)

      expect(new_review.title).must_equal 'So Good'
      expect(new_review.rating).must_equal 5
      expect(new_review.description).must_equal 'How did I get such a perfect plant'
    end

    it "leaves a review if you are logged in and NOT the product's merchant" do
      perform_login(merchants(:merchant_2))

      expect {
        post product_reviews_path(product_id: @product.id), params: create_review 
      }.must_change 'Review.count', 1
    end

    it "does not leave a review if you are logged in as the product's merchant" do
      perform_login(merchants(:merchant_1))

      expect(session[:user_id]).must_equal merchants(:merchant_1).id

      expect {
        post product_reviews_path(product_id: @product.id), params: create_review 
      }.wont_change 'Review.count'
    end
    
    it "review is invalid if validations fail" do
      create_review[:review][:title] = nil

      expect {
        post product_reviews_path(product_id: @product.id), params: create_review 
      }.wont_change 'Review.count'
    end
  end

end
