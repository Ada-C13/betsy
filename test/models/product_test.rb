require "test_helper"

describe Product do
  describe 'relations' do 
    it "can have many order_items" do 
      product = products(:product_1)
      order = orders(:order_1)

      count = product.order_items.count

      order_item1 = OrderItem.create(product: product,quantity:1 , order:order)
      order_item2 = OrderItem.create(product: product,quantity:1 , order:order)
      expect(product.reload.order_items.count).must_equal count + 2 

    end 

    it "can have many reviews" do 
      product = products(:product_1)

      count = product.reviews.count

      review_1 = Review.create(product: product, rating: 3)
      expect(product.reload.reviews.count).must_equal count + 1 
    end 
  end 

  describe 'average_rating' do
    it 'returns correct rating for a product' do
      product = products(:product_1)

      expect(product.average_rating).must_include "3.0"
    end

    it 'returns no reviews yet for product with no reviews' do
      product = products(:product_4)

      expect(product.average_rating).must_equal "No reviews yet"
    end
  end

  describe 'reviews_length' do
    it 'returns singular review text for product with one review' do
      product = products(:product_2)
      expect(product.reviews_length).must_equal "1 review"
    end

    it 'returns text with plural reviews for product with more than one review' do
      product = products(:product_1)
      expect(product.reviews_length).must_equal "2 reviews"
    end

    it 'returns text with plural reviews for product with more than one review' do
      product = products(:product_3)
      expect(product.reviews_length).must_equal "0 reviews"
    end
  end

  describe "featured" do 
    it "selects three active products" do 
      # featured_items = homepages.featured
      expect(Product.featured.length).must_equal 3
    end 
  end
end
