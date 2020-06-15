require "test_helper"

describe ReviewsController do
  let(:product) { products(:daisy) }

  it "should get new" do
    get new_review_url
    must_respond_with :success
  end

  it "should create new review" do
    assert_difference("Review.count") do
      post reviews_url, params: { review: { rating: 5, comment: "I was happy with my daisies!", product_id: product.id  } }
    end

    must_redirect_to review_url(Review.last)
  end

  it "can't create with out rating" do
    assert_no_difference("Review.count") do
      post reviews_url, params: { review: { rating: nil, comment: "I wasn't happy with my daisies!", product_id: product.id  } }
    end

    must_redirect_to review_path
  end

  it "can't create when rating that is above 5" do
    assert_no_difference("Review.count") do
      post reviews_url, params: { review: { rating: 8, comment: "I was really happy with my daisies!", product_id: product.id  } }
    end

    must_redirect_to review_path
  end
end
