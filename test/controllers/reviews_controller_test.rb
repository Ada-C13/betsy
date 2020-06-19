require "test_helper"

describe ReviewsController do
  before do
    @product = products(:product1)
    @product1 = products(:product2)
    @review1 = reviews(:review1)
    @review = Review.new(rating: @review1.rating, feedback: @review1.feedback )
    # @merchant = merchants(:merchantaaa)
    # perform_login(@merchant)

  end

  it "responds with success when there are many reviews saved" do
    # Ensure that there is at least one Categoty saved
    @review.save
    get product_reviews_path(@product.id)
    must_redirect_to root_path
  end

  it "responds with success when there are no reviews saved" do
    # Ensure that there are zero Categoty saved
    get product_reviews_path(@product.id)
    must_redirect_to root_path
  end
  
  describe "create" do
    before do
      @review_hash = {
        review: {
          rating: 1,
          feedback: 'Very nice product'
        }
      }
    end
    it "can create a new review with valid information accurately" do
      # Ensure that there is a change of 1 in Review.count
      post create_review_path(@product.id), params: @review_hash
      expect(Review.last.rating).must_equal @review_hash[:review][:rating]
      expect(Review.last.feedback).must_equal @review_hash[:review][:feedback]
      expect { 
        post create_review_path(@product.id), params: @review_hash
      }.must_differ "Review.count", 1

      

      must_redirect_to product_path(@product.id)
    end

    it "can not create a new review for the own product" do
      @merchant = merchants(:merchantaaa)
      perform_login(@merchant)
      # Product1 is created by merchant :merchantaaa in fixture, so this user can not review the own product
      expect { 
        post create_review_path(@product.id), params: @review_hash
      }.wont_change "Review.count"
#      expect(flash[:warning]).must_equal "Sorry, You cannot a review for your own product."
      must_redirect_to product_path(@product1.id)
    end

    it "can not create a new review if product does not exist" do
      expect { 
        post create_review_path(-1), params: @review_hash
      }.wont_change "Review.count"
      must_respond_with :not_found
    end

    it "can not create new review if data are missing" do
      @review_hash[:review][:rating] = nil

      expect { 
        post create_review_path(@product.id), params: @review_hash
      }.wont_change "Review.count"

      expect(flash[:warning]).must_equal "A problem occurred: Could not add a review"
  
      assert_response :bad_request
    end
  end
end
