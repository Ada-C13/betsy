require "test_helper"

describe Category do
  describe "initialize" do
    before do
      @category = Category.new(name: "Miscellaneous")
    end

    it "can be instatiated" do
      expect(@category.valid?).must_equal true
    end

    it "has required fields" do
      expect(@category).must_respond_to :name
    end
  end

  describe "validations" do
    let(:fossils) {categories(:fossils)}

    describe "name" do
      it "has a name that is a string" do
        expect(fossils.name).must_be_instance_of String
        expect(fossils.name).must_equal categories(:fossils).name
      end

      it "does not allow an empty string for a name" do
        fossils.name = ""

        expect(fossils.valid?).must_equal false
        expect(fossils.errors.messages).must_include :name
        expect(fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "does not allow a string of whitespace for a name" do
        fossils.name = " "

        expect(fossils.valid?).must_equal false
        expect(fossils.errors.messages).must_include :name
        expect(fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "cannot be nil" do
        fossils.name = nil

        expect(fossils.valid?).must_equal false
        expect(fossils.errors.messages).must_include :name
        expect(fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must be unique" do
        same_category = Category.new(name: "fossils")

        expect(same_category.valid?).must_equal false
        expect(same_category.errors.messages).must_include :name
        expect(same_category.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end
  end

  describe "relationships" do 
    let(:fossils) {categories(:fossils)}
    let(:tops) {categories(:tops) }
    let(:furniture) {categories(:furniture)}

    describe "products" do
      it "can have no products" do 
        new_category = Category.new(name: "Other")

        expect(new_category.valid?).must_equal true
      end

      it "can have more than one product" do
        expect(fossils.products.count).must_equal fossils.products.count

        expect(fossils.products.first).must_be_instance_of Product
        expect(tops.products.count).must_equal tops.products.count
        expect(furniture.products).must_be_empty
        expect(furniture.products.length).must_equal 0
      end
    end

    it "removes category relationship when product is deleted" do
      og_count = tops.products.count
      products(:shirt).destroy

      expect(tops.products.count).must_equal (og_count - 1)
    end
  end

  describe "custom methods" do 
    describe "Category.search_result" do 
      it "can search by category" do 
        expect(Category.search_result("bottom")).must_be_instance_of Integer
        expect(Category.search_result("bottom")).must_equal 2
      end
    end
  end
end
