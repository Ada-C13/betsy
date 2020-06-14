require "test_helper"

describe Review do
  before do
    @product = products(:banana)
    @review = Review.new(text: "Cool", rating: 5, product_id: @product.id)
  end
  it "can be instantiated" do
    # Arrange
    review = Review.new(text: "Test", rating: 2, product_id: @product.id)
    review.save
    # Assert
    expect(Review.last).must_equal review
  end

  it "has the required fields" do
    # Arrange
    review = Review.new(text: "Test", rating: 2, product_id: @product.id)
    review.save
    # Assert
    result = Review.last
    expect(result.id).must_equal review.id
    expect(result.text).must_equal review.text
    expect(result.rating).must_equal review.rating
    expect(result.product_id).must_equal @product.id
    expect(result.created_at).wont_be_nil
  end

  describe 'validations' do
    it "is valid when all fields are filled" do
      result = @review.valid?
      expect(result).must_equal true
    end

    it 'is invalid when text is not unique' do
      new_review = Review.new(text: @review.text)
      expect(new_review.valid?).must_equal false
    end

    it 'fails validation when title is nil' do
      @review.text = nil
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:text)).must_equal true
      expect(@review.errors.messages[:text].include?("can't be blank")).must_equal true
    end

    it 'is valid when rating is in 1-5 range, inslusively' do
      @review.rating = 1
      expect(@review.valid?).must_equal true
      @review.rating = 5
      expect(@review.valid?).must_equal true
    end

    it 'fails validation when rating is nil' do
      @review.rating = nil
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("can't be blank")).must_equal true
    end

    it 'fails validation when rating is out of range 1-5' do
      @review.rating = 10
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("is not included in the list")).must_equal true
    end
  end

  describe 'relations' do
    it "belongs to a product" do
      @product.reviews << @review
      expect(@product.reviews.count).must_equal 1
      expect(@review.product).must_equal @product
    end

    it 'permits a product to have many reviews' do
      product = products(:banana)
      product.reviews << @review
      expect(@product.reviews.count).must_equal 1
      review2 = Review.new(text: "Test2", rating: 3, product_id: @product.id)
      product.reviews << review2
      expect(product.reviews.count).must_equal 2
      expect(review2.product.id).must_equal product.id
      expect(@review.product.id).must_equal product.id
    end

    it 'permits a product to have zero reviews' do
      expect(@product.reviews.count).must_equal 0
    end
  end
end
