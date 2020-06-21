require "test_helper"

describe ReviewsController do
  require "test_helper"

  describe Review do
    describe "new" do
      it "can successfully retrieve new review page for valid product id" do
        get new_review_path(product_id: Product.first.id)
        assert_response :success
      end
    end

    describe "create" do
      let(:product) { products(:rx_bar) }
      it "can create a valid review and redirects to product page" do
        valid_hash = {
          review: {
            rating: 5,
            product_id: product.id
          },
        } 

        assert_difference("Review.count") do
          post reviews_path(product.id), params: valid_hash 
        end

        new_review = Review.last
        
        expect(new_review.rating).must_equal 5
        expect(new_review.product_id).must_equal products(:rx_bar).id
        
        must_redirect_to product_path(new_review.product_id)
        must_redirect_to product_path(products(:rx_bar).id)

        assert_equal "Review successfully added.", flash[:success]
      end
    end
  end
end
