require "test_helper"

describe Category do

  describe "relationships" do 
    it "has many products" do 
      category = categories(:category_2)

      expect(category.products.length).must_equal 3
    end 
  end 
  
  describe "validations" do 
    it "is invalid without a name" do 
      category = categories(:category_1)
      category.name = ''
      
      expect(category.valid?).must_equal false  
    end
  end
  
end
