require "test_helper"

describe Category do
  let(:category) { categories(:flower) }

  describe "validations" do
    it "is valid when name is present" do
      expect(category.valid?).must_equal true
    end

    it "is invalid when name is missing" do
      category.name = nil
      expect(category.valid?).must_equal false
      expect(category.errors.messages).must_include :name
    end

    it "is invalid when category already exists" do
      repeated_category = Category.new(
        name: category.name,
        description: "repeated category"
      )
      expect(repeated_category.valid?).must_equal false
      expect(repeated_category.errors.messages).must_include :name
    end
  end

  describe "relationships" do
    it "has/responds to products" do
      expect(category.respond_to?(:products)).must_equal true
    end
  end

end
