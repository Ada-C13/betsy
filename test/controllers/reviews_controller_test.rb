require "test_helper"

describe ReviewsController do
  let (:new_product) {products(:t_rex_tail)}

  describe "unauthenticated" do
    describe "new" do
      it 'can see the form to add a review' do
        get new_product_review_path(new_product.id)
        
        must_respond_with :success
      end
    end

    describe "create" do   
      it "can create a review" do 
        review_hash = {
          product_id: new_product.id,
          reviewer: "Kyle",
          rating: 4,
          description: "It's amazing"
        }

        expect {post product_reviews_path(new_product.id), params: review_hash}.must_differ "Review.count", 1
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
      
      it "will not create a new review if invalid fields are given" do 
        review_hash = {
          product_id: new_product.id,
          reviewer: "camden",
          rating: nil,
          description: "Awesome"
        }
        
        expect {post product_reviews_path(new_product.id), params: review_hash}.wont_change "Review.count"
        
        expect(flash.now[:error]).must_include "A problem occurred: Could not update the review"
        expect(flash.now[:error]).must_include "can't be blank"
        must_respond_with :redirect 
        must_redirect_to root_path
      end
    end
  end

  describe "authenticated" do
    before do 
      @user = users(:pengsoo)
      @product = products(:dog_nose)
      @my_product = products(:pengsoo_nose)
      login(@user)
    end

    describe "new" do
      it 'can see the form to add a review' do
        get new_product_review_path(@product.id)
        
        must_respond_with :success
      end
    end

    describe "create" do 
      it "will create a new review for another merchant's product" do 
        review_hash = {
          product_id: @product.id,
          rating: 5,
          description: "Awesome"
        }

        expect{
          post product_reviews_path(@product.id), params: review_hash
        }.must_differ "Review.count", 1

        must_redirect_to root_path
        expect(flash[:success]).must_include "The review was successfully added! 😄"
      end

      it "will not create a new review for my product" do 
        review_hash = {
          product_id: @my_product.id,
          rating: 4,
          description: "Awesome"
        }

        expect{
          post product_reviews_path(@my_product.id), params: review_hash
        }.wont_change "Review.count"

        must_redirect_to root_path
        expect(flash[:error]).must_include "Cannot add a review for your own product!"
      end
    end
  end
end