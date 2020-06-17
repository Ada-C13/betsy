require "test_helper"

describe CategoriesController do
  before do
    @categories = Category.new(name: "category")
    @merchant = merchants(:merchantaaa)
    perform_login(@merchant)
  end

  describe "index" do
    it "responds with success when there are many categories saved" do
      # Ensure that there is at least one Categoty saved
      @categories.save
      get categories_path
      must_respond_with :success
    end

    it "responds with success when there are no categories saved" do
      # Ensure that there are zero Categoty saved
      get categories_path
      must_respond_with :success
    end
  end

  describe "new" do
    it "responds with success" do
      get new_category_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid category" do
      @categories.save
      get category_path(@categories.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid category id" do
      get category_path(-1)
      must_redirect_to categories_path
    end
  end

  describe "create" do
    before do
      @category_hash = {
        category: {
          name: 'test'
        }
      }
    end

    it "can create a new category with valid information accurately if the user is logged in, and redirect" do
      # Ensure that there is a change of 1 in Category.count
      expect { 
        post categories_path, params: @category_hash
      }.must_differ "Category.count", 1

      expect(Category.last.name).must_equal @category_hash[:category][:name]

      must_redirect_to account_path(@merchant.id)
    end

    it "does not create a category if name is not present, and responds with a redirect" do
      # Ensure that there is a no change of 1 in Category.count
      @category_hash[:category][:name] = nil

      expect { 
        post categories_path, params: @category_hash
      }.wont_change "Category.count"

      assert_response :bad_request
    end
  end
  
end
