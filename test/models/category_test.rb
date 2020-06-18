require "test_helper"

describe Category do
  before do
    @category = Category.new(name: "xxxxxx")
    @category1 = categories(:category1)
    @category3 = categories(:category3)
  end

  it "category will have the required field" do
    [:name].each do |field|
      expect(@category1).must_respond_to field
    end
  end

  describe 'relations' do
    it 'has meny products' do
      expect(@category1.products).must_respond_to :each

      @category1.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "validations" do
    it "it's valid when category has name" do
      @category1.name = "medical supplies"
      expect(@category1.valid?).must_equal true
    end

    it "requires a name" do
      category = Category.new
      expect(category.valid?).must_equal false
      expect(category.errors.messages).must_include :name
    end

    it "requires a unique name" do
      name = "test name"
      category1 = Category.new(name: name)

      # This must go through, so we use create!
      category1.save!

      category2 = Category.new(name: name)
      result = category2.save
      expect(result).must_equal false
      expect(category2.errors.messages).must_include :name
    end
  end
end
