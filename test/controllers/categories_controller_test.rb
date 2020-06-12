require "test_helper"

describe CategoriesController do
  before do
    @categories = Category.new(name: "pets")
  end
  let (:category_hash) {
    {
      ategory: {
        name: "pets", 
      }
    }
  }
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





  # it "must get index" do
  #   get categories_index_url
  #   must_respond_with :success
  # end

  # it "must get new" do
  #   get categories_new_url
  #   must_respond_with :success
  # end

end
