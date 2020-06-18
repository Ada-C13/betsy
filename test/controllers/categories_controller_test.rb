require "test_helper"

describe CategoriesController do
  before do
    @category = Category.new(name: "category")
    @merchant = merchants(:merchantaaa)
    perform_login(@merchant)

    @category1 = categories(:category1) # This category links to 6 products
    @category3 = categories(:category3) # This category doesn't link to any product
  end

  describe "index" do
    it "responds with success when there are many categories saved" do
      # Ensure that there is at least one Categoty saved
      @category.save
      get categories_path
      must_redirect_to root_path
    end

    it "responds with success when there are no categories saved" do
      # Ensure that there are zero Categoty saved
      get categories_path
      must_redirect_to root_path
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
      @category_hash = {
        category: {
          name: 'Test'
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

  describe "#category_products" do
    it "responds with 404 with an invalid category id" do
      get category_product_path(-1)
      must_redirect_to categories_path
    end

    it "should return all products that belongs to one category" do
      get category_product_path(@category1)
      all_products_catetory1 = @category1.products
      expect(all_products_catetory1.length).must_equal 6
      must_respond_with :success
    end

    it "will return empty array if we dont have any product for specific category" do
      get category_product_path(@category3)
      all_products_catetory3 = @category3.products
      expect(all_products_catetory3.length).must_equal 0
      must_respond_with :success
    end
  end
end
