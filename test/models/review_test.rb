require "test_helper"

describe Review do

  let (:new_review) {
    Review.new(
      title: 'So Good',
      rating: 5,
      description: 'How did I get such a perfect plant',
      product_id: products(:product_1).id
    )
  }
  
  it "can be instantiated" do
    expect(new_review.valid?).must_equal true
  end

  it "will have the required fields" do
    new_review.save

    expect(Review.first).must_respond_to :title
    expect(Review.first).must_respond_to :rating
    expect(Review.first).must_respond_to :description
    expect(Review.first).must_respond_to :product_id
  end

  describe "relationships" do
    it "review can have product" do
      new_review.save

      expect(new_review.product).must_be_instance_of Product
      expect(new_review.product.name).must_equal "Product 1"
    end

    it "product can have review" do
      new_review.save

      expect(Product.find_by(id: new_review.product_id).reviews.count).must_equal 1
      expect(Product.find_by(id: new_review.product_id).reviews[0]).must_be_instance_of Review
    end 
  end

  describe "validations" do
    it "must have a title" do
      new_review.title = nil

      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :title
    end

    it "must have a rating" do
      new_review.rating = nil

      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
    end

    it "must have a description" do
      new_review.description = nil

      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :description
    end
  end

end
