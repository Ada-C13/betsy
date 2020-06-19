require "test_helper"

describe CategoriesController do

  let (:product_1) {
    products(:product_1)
  }

  let (:product_2) {
    products(:product_2)
  }

  let (:category_1) {
    categories(:category1)
  }

  let (:category_2) {
    categories(:category2)
  }

  let (:category_hash) {
    {
      category: {
        name: "Flowers",
      }
    }
  }

  describe "index" do
    it "must get index" do
      get categories_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "must get a page for a specific category" do
      get category_path(category_1.id)
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      invalid_category_id = 999
  
      get category_path(invalid_category_id)
  
      must_respond_with :not_found
    end
  end

  describe "new" do    
    it "a not logged in user is redirected" do
      get new_category_path
      
      must_respond_with :redirect
      must_redirect_to root_path
    end

    describe "logged in" do
      before do
        perform_login()
      end

      it "must get form to create a new category" do
        get new_category_path
        must_respond_with :success
      end
    end
  end

  describe "create" do
    it "redirects and can't create a new category when not logged in" do
      expect{ post categories_path, params: category_hash }.must_differ 'Category.count', 0
      
      must_respond_with :redirect
      must_redirect_to root_path
    end

    describe "logged in" do
      before do
        perform_login()
      end

      it "a logged in merchant can create a new category" do
        expect {
          post categories_path, params: category_hash
        }.must_differ 'Category.count', 1

        must_respond_with :redirect
        must_redirect_to categories_path

        expect(Category.last.name).must_equal category_hash[:category][:name]
      end
    end
  end

end
