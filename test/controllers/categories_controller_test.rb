require "test_helper"

describe CategoriesController do
  describe "new" do 
    it "responds with not_found if there is no sigged-in user" do 
      get new_category_path 
      must_respond_with :not_found
    end

    it "responds with success" do
      perform_login(merchants(:merchant1))
      get new_category_path 
      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new category with valid information, and redirect" do 
      category_hash = {
        category: {
          title: "Crystal"
        }
      }
      expect {
        post categories_path, params: category_hash
      }.must_differ "Category.count", 1

      new_category = Category.last
      expect(new_category.title).must_equal category_hash[:category][:title]

      must_respond_with :redirect 
      must_redirect_to new_product_path
    end

    it "does not create a new category if the form data violates Category validations" do 
      category_hash = {
        category: {
          title: ""
        }
      }

      expect {
        post categories_path, params: category_hash
      }.must_differ "Category.count", 0

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_include "Could not create category"
      expect(flash[:messages].first).must_include :title
      expect(flash[:messages].first).must_include ["can't be blank"]
    end
  end
end
