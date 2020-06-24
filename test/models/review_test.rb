require "test_helper"

describe Review do
  describe "initialize" do
    before do
      @review = Review.new(description: "very good thing", rating: 4, reviewer: "harry", product_id: products(:shirt).id)
    end
    
    it "can be instantiated" do
      expect(@review.valid?).must_equal true
      expect(@review).must_be_instance_of Review
    end

    it "has required fields" do
      @review.save

      [:description, :rating, :reviewer, :product_id].each do |field|
        expect(@review).must_respond_to field
      end
    end
  end

  describe "validations" do
    before do 
      @review = Review.create(description: "horrible, what a crooked tanooki", rating: 1, reviewer: "self", product_id: products(:amber).id)
    end

    it "must have a description" do
      @review.description = nil

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :description
      expect(@review.errors.messages[:description]).must_equal ["can't be blank"]
    end

    describe "rating" do
      it "must have a rating" do
        @review.rating = nil

        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :rating
        expect(@review.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
      end

      it "must be a number" do
        @review.rating = "sdf"

        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :rating
        expect(@review.errors.messages[:rating]).must_equal ["is not a number"]
      end

      it "must be greater than 0" do
        @review.rating = 0

        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :rating
        expect(@review.errors.messages[:rating]).must_equal ["must be greater than 0"]
      end

      it "must be less than 6" do
        @review.rating = 9

        expect(@review.valid?).must_equal false
        expect(@review.errors.messages).must_include :rating
        expect(@review.errors.messages[:rating]).must_equal ["must be less than 6"]
      end
    end

    it "must have a reviewer" do
      @review.reviewer = nil
      
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :reviewer
      expect(@review.errors.messages[:reviewer]).must_equal ["can't be blank"]
    end

    it "must have a product id" do
      @review.product_id = nil
      
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :product_id
      expect(@review.errors.messages[:product_id]).must_equal ["can't be blank"]
    end
  end

  describe "relationships" do
    let(:review) {reviews(:review)}

    it "has a product" do
      expect(review.product).must_be_instance_of Product
    end

    it "sets a product through product" do
      review = Review.new(description: "very good thing", rating: 4, reviewer: "harry")
      review.product_id = products(:amber).id

      expect(review.valid?).must_equal true
      expect(review.product).must_equal products(:amber)
    end

    it "sets a product through product_id" do
      review = Review.new(description: "very good thing", rating: 4, reviewer: "harry")
      review.product_id = products(:amber).id

      expect(review.valid?).must_equal true
      expect(review.product).must_equal products(:amber)
    end
  end

  describe "custom methods" do
    describe "Review.display_rating" do
      it "can convert rating from integer to star symbols" do 
        expect(Review.display_rating(5)).must_equal "★★★★★"
        expect(Review.display_rating(1)).must_equal "★☆☆☆☆"
      end
    end
  end
end
