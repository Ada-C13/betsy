require "test_helper"

describe Product do
  describe "validations" do
    before do
      @collar = products(:collar)
    end

    it "name must be present and unique" do 
      expect(@collar.name).must_equal "collar"

      duplicate_item = @collar.dup
      duplicate_item.save
      expect(duplicate_item.valid?).must_equal false
    end

    it "should give error if name is nil" do 
      @collar.name = nil
      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :name
    end

    it "should give error if name is blank" do 
      @collar.name = "   "
      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :name
    end

    it "is invalid when name not unique" do 
      @leash = products(:leash)
      @leash.name = "collar"
      expect(@leash.valid?).must_equal false
      expect(@leash.errors.messages).must_include :name
    end

    it "is invalid with price not present" do 
      @collar.price = nil
      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :price
    end

    it "is invalid when price is not a number" do 
      @collar.price = "test"
      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :price
    end

    it "invalid when price is not greater than zero" do 
      @collar.price = -1
      expect(@collar.valid?).must_equal false
      expect(@collar.errors.messages).must_include :price
   end
  end

  describe "relations" do
    it "has a user" do
      product = products(:collar)
      expect(product.user_id).must_equal products(:collar).user_id
    end
  end
  
  describe "average_rating" do
    it 'calculates average rating' do
      
      Review.create(rating: 5, text: "good", product_id: Product.first.id)
      Review.create(rating: 2, text: "poor", product_id: Product.first.id)
      Review.create(rating: 5, text: "excellent", product_id: Product.first.id)
      
      expect(Product.first.average_rating).must_equal 4
    end
  end
 
  describe "spotlight" do
    it "gets the newest product" do
      expect(Product.spotlight(Product.all)).must_equal Product.last
    end
  end

  describe "top rated" do
    it "gets highest rated products" do
      Review.create(rating: 5, text: "good", product_id: Product.first.id)
      Review.create(rating: 2, text: "poor", product_id: Product.first.id)
      Review.create(rating: 5, text: "excellent", product_id: Product.first.id)

      expect(Product.top_rated(Product.all)).must_include Product.first
    end
  end

  describe "decrease stock" do
    it "will decrease stock" do
      expect(Product.first.decrease_inventory(Product.first.stock)).must_be_kind_of Integer    
      expect(Product.first.decrease_inventory(Product.first.stock)).must_equal 0     
     end
  end
end
