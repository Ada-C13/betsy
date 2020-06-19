require "test_helper"

describe Review do
  describe "relations" do

    it "has an product" do
      review = reviews(:review1)
      expect(review).must_respond_to :product
      product = products(:product1)
      review.product_id = product.id
      expect(review.product).must_be_kind_of Product
    end

  end

  describe "validations" do
    let(:review4) {
      Review.new(
        rating: 4,
        description: "just good enough",
        product: products(:product1)
      )
    }

    it "is valid for a review with all required fields" do
      expect(review4.valid?).must_equal true
    end 

    it "has the required fields" do
      review4.save
      new_review = Review.last
    
      [:rating, :description].each do |field|
        expect(new_review).must_respond_to field
      end
    end

    it "is invalid without a rating" do
      review4.rating = nil
    
      expect(review4.valid?).must_equal false
      expect(review4.errors.messages).must_include :rating
    end

    it "cannot creat a new review with a non integer rating" do
      review4.rating = 3.4
    
      expect(review4.valid?).must_equal false
      expect(review4.errors.messages).must_include :rating
    end

    it "cannot creat a new review with a rating other than between 1 to 5 inclusive" do
      review4.rating = 6
    
      expect(review4.valid?).must_equal false
      expect(review4.errors.messages).must_include :rating
    end

  end
end
