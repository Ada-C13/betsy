require "test_helper"

describe Review do

  before do
    @toy = Product.create(
      name: "chewy toy",
      price: 4.99,
      description: "a fun toy for your dog",
      stock: 2,
      photo_url: "https://dogtime.com/assets/uploads/2011/03/puppy-development-1280x720.jpg",
      user_id: users(:grace).id
    )
    @review = Review.new(rating: 5, text: "Great!")
  end

  describe "relations" do
    it 'belongs to a product' do
      @review.product_id = @toy.id
      expect(@review.product_id).must_equal @toy.id
    end
  end

  describe "validations" do
    it "can create a valid review" do
      expect(@review.valid?).must_equal false
    end

    it "cannot create a review without a rating" do
      @review.rating = nil
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :rating
    end
    
  end
end
