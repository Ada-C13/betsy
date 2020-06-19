require "test_helper"

describe Review do
  describe "validations" do
    it "passes validation if valid rating is provided" do
      review = reviews(:review_1)
      expect(review.valid?).must_equal true
    end

    it "fails validation if no rating is provided" do
      review = reviews(:review_1)
      review.rating = nil
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

    it "fails validation if rating is not valid" do
      review = reviews(:review_1)
      review.rating = 4.44
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating

      review.rating = 8
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

    it "passes validation if valid product_id is provided" do
      review = reviews(:review_1)
      expect(review.valid?).must_equal true
    end

    it "fails validation if non-existent product_id is provided" do
      review = reviews(:review_1)
      review.product_id = -1
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :product
    end
  end
end
