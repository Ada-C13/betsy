require "test_helper"

describe Category do
  before do
    @category = Category.new(title: "Test")
  end
  it "can be instantiated" do
    # Arrange
    category = Category.new(title: "Test")
    category.save
    # Assert
    expect(Category.last).must_equal category
  end

  it "has the required fields" do
    # Arrange
    category = Category.create(title: "Test")
    # Assert
    result = Category.last
    expect(result.id).must_equal category.id
    expect(result.title).must_equal category.title
    expect(result.created_at).wont_be_nil
  end

  describe 'validations' do
    it "is valid when all fields are filled" do
      result = @category.valid?
      expect(result).must_equal true
    end

    it 'is invalid when title is not unique' do
      @category.save
      new_category = Category.new(title: @category.title)
      expect(new_category.valid?).must_equal false
    end

    it 'fails validation when title is nil' do
      @category.title = nil
      expect(@category.valid?).must_equal false
      expect(@category.errors.messages.include?(:title)).must_equal true
      expect(@category.errors.messages[:title].include?("can't be blank")).must_equal true
    end
  end

  describe 'relations' do
    it "has 'products' through categories_products table" do
      product = products(:banana)
      product.categories << @category
      expect(@category.products.count).must_equal 1
      expect(@category.products.first).must_equal product
    end

    it 'permits a category to have many products' do
      product = products(:banana)
      product.categories << @category
      expect(@category.products.count).must_equal 1
      product2 = products(:apple)
      product2.categories << @category
      expect(@category.products.count).must_equal 2
    end

    it 'permits a category to have zero products' do
      expect(@category.products.count).must_equal 0
    end
  end
end
