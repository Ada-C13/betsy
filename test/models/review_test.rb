require "test_helper"

describe Review do
  before do
    @product = products(:product1)
    @review = reviews(:review1)
  end

  describe "Guest User" do
    describe "belongs_to relationship" do
      it "reviews belongd to a product" do
        # Arrange & Act
        reviews().each do |review|
          @product.reviews << reviews
        end
        # Assert
        @product.reviews.each do |review|
          expect(review).must_be_instance_of Review
          expect(review.product_id).must_equal @product.id
        end
      end

      it "set the product review through product id" do
        @review.product_id = @product.id
        expect(@review.product).must_equal @product
      end
    end

    describe "validation" do
      it "review must have a rating" do
        # Arrange
        @review.product_id = @product.id
        @review.rating = nil
        # Assert
        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :rating
        expect(@review.errors.messages[:rating]).must_include "can't be blank"
        expect(@review.errors.messages[:rating]).must_include "is not a number"
      end
  
      it "it's valid when review has rating" do
        @review.product_id = @product.id
        expect(@review.valid?).must_equal true
      end
  
      it "review must have a feedback" do
        # Arrange
        @review.product_id = @product.id
        @review.feedback = nil
        # Assert
        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :feedback
        expect(@review.errors.messages[:feedback]).must_equal ["can't be blank"]
      end
  
      it "it's valid when review has feedback" do
        @review.product_id = @product.id
        expect(@review.valid?).must_equal true
      end
    end
  end
end
