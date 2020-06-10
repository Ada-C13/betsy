require "test_helper"

describe Review do
  let (:review) {reviews(:review_one) }
  let (:product) {products(:daisy) }
  before do
    review.product_id = product.id
  end
  

  describe "validations" do

    it "is valid when a review has rating" do
      expect(review.valid?).must_equal true
      
    end

    it "is not valid without a rating" do
      review.rating = nil
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      
    end

    it "is not valid if the rating isn't between 0-5" do
      review.rating = 7
      result = review.valid?

      expect(result).must_equal false
      expect(review.errors.messages).must_include :rating
      expect(review.errors.messages[:rating]).must_include " should be between 0 to 5"

    end

    it 'is not valid if rating is not a number' do
      review.rating = "not a number"
      result = review.valid?

      expect(result).must_equal false
      expect(review.errors.messages).must_include :rating
      expect(review.errors.messages[:rating]).must_include "is not a number"
    end


  end


  describe "relationships" do
    it "belongs to a product" do
      expect(review.respond_to?(:product)).must_equal true
    end
  end

end
