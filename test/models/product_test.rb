require "test_helper"

describe Product do
  describe "custom methods" do
    describe "get_active_products" do 
      it "returns only the products where active is set to true" do 
        active_products = Product.get_active_products

        expect(active_products).must_equal 1
      end
    end
  end
end
