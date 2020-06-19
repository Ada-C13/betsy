require "test_helper"

describe CategoriesController do
  # TODO: differentiate between logged in user and non-logged in

  describe "show" do
    it "will get show for valid ids" do
      category = Category.create(name: "something")
      get category_path(category.id)
      must_respond_with :success
    end
    it "will respond with not_found for invalid id" do
      get category_path(-1)
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "will bring user to new category form" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a category" do
      category_hash = {
        category: {
          name: "something"
        }
      }
      expect { post categories_path, params: category_hash }.must_differ 'Category.count', 1
      must_redirect_to root_path
    end
    it "will not create a category with invalid data" do
      category_hash = {
        category: {
          name: nil
        }
      }
      expect { post categories_path, params: category_hash }.wont_change 'Category.count'

    end
  end
end
