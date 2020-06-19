require "test_helper"

describe CategoriesController do
  
  describe "Guest users" do
    before do
      @category = Category.first
    end

    it "guest can access product by category" do
      get category_products_path(@category.id)
      must_respond_with :success
     
    end
  end

  describe "create" do

    before do
      @merchant = perform_login()
    end

   let(:category_hash) { 
    {
      category: {
        name: "stuff",
      }
    }
  }

    it "can create a category" do
      expect {
        post categories_path, params: category_hash
      }.must_differ 'Category.count', 1
  
      must_respond_with :redirect
      must_redirect_to root_path
      expect(Category.last.name).must_equal category_hash[:category][:name]
    end

    it "will not create a category with invalid params" do
      category_hash[:category][:name] = nil

      expect {
        post categories_path, params: category_hash
      }.must_differ "Category.count", 0

      must_respond_with :bad_request
    end
  end

  describe "new" do
    it "can get the new_category_path" do
      get new_category_path

      must_respond_with :success
    end
  end
end
