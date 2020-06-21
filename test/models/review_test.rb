require "test_helper"
describe Review do
  before do
    @product = products(:rx_bar)
    @review = reviews(:review_one)
    @review.product_id = @product.id
  end

  describe "validations" do
  
    # rating VALIDATIONS:
    it "is valid with a valid integer rating" do
      expect(@review.valid?).must_equal true
      expect(@review.rating).must_be_kind_of Integer
      expect(@review.rating).must_equal 5
    end

    it "is invalid without a rating" do
      @review.rating = nil
      expect(@review.valid?).must_equal false
    end

    it "is invalid with a rating outside 1 through 5" do
      # 0 rating
      @review.rating = 0
      @result = @review.valid?

      expect(@result).must_equal false

      # Negative rating
      @review.rating = -1
      @result = @review.valid?

      expect(@result).must_equal false

      # > 5 rating
      @review.rating = 6
      @result = @review.valid?

      expect(@result).must_equal false
    end

    it "is invalid with an incorrect rating data type" do
      @review.rating = "FIVE"
      @result = @review.valid?

      expect(@result).must_equal false
    end
  end
end
