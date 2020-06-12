require "test_helper"

describe CategoriesController do
  before do
    @categories = Category.new(name: "category")
  end
  # let (:category_hash) {
  #   {
  #     category: {
  #       name: "pets", 
  #     }
  #   }
  # }

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

  describe "create" do
    before do
      @category_data = {
        category: {
          name: 'test category'
        }
      }
    end
    it "can create a new category with valid information accurately, and redirect" do
      # Ensure that there is a change of 1 in Category.count
      expect { 
        post categories_path, params: @category_data
      }.must_differ "Category.count", 1

       
      # Find the newly created Category, and check that all its attributes match what was given in the form data
      expect(Category.last.name).must_equal @category_data[:category][:name]
   
      # Check that the controller redirected the user
      must_redirect_to categories_path(Category.last.id)
    end
  end





end
