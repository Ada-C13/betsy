require "test_helper"

describe ReviewsController do

  before do
    @toy = Product.create(
      name: "chewy toy",
      price: 4.99,
      description: "a fun toy for your dog",
      stock: 2,
      photo_url: "https://dogtime.com/assets/uploads/2011/03/puppy-development-1280x720.jpg",
      user_id: users(:grace).id
    )
  end

  describe "new" do

    it "responds with success" do
      get new_product_review_path(@toy)
      must_respond_with :success
    end

  end

  describe "create" do

    it "can create a valid review" do
      valid_hash = {
        review: {
          rating: 5,
          text: "the best",
          product: @toy
        }
      }
      expect { post product_reviews_path(product_id: @toy.id), params: valid_hash }.must_change "Review.count", 1 # product needs user_id
      expect(Review.last.rating).must_equal valid_hash[:review][:rating]
      expect(Review.last.text).must_equal valid_hash[:review][:text]
      expect(Review.last.product_id).must_equal @toy.id

      must_redirect_to product_path(id: @toy.id)
    end

    it "cannot create an invalid review" do
      invalid_hash = {
        review: {
          rating: nil,
          text: "the best",
          product: @toy
        }
      }
      expect { post product_reviews_path(product_id: @toy.id), params: invalid_hash }.wont_change "Review.count" # no product

      must_respond_with :redirect # test error: getting 200 OK instead of 3XX redirect
    end

    it "does not allow users to review their own products" do
      perform_login(users(:grace))
      
    end

  end


end
