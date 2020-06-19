require "test_helper"

describe CategoriesController do
  it "responds with success" do 
    @category = categories(:category_1)
    get "/categories/#{@category.id}"

    must_respond_with :success 

  end 

  it "gives an error if incorrect category passed in" do 

    @category = categories(:category_1)
    @category.id = -1
    get "/categories/#{@category.id}"

    expect(flash[:error]).must_include "Category does not exist"
    must_respond_with :not_found 
  end 

  describe "create" do 

    it "can create new category" do 
      category_hash = {
        category: {
          name: "funny category"
        }
      }
      perform_login(merchants(:merchant_1))
      expect{post categories_path, params: category_hash}.must_change "Category.count", 1
      expect(flash[:success]).must_include "has been added to the category database"
    end 

    it "cannot create category if name is blank" do 
      category_hash = {
        category: {
          name: nil
        }
      }
      count = Category.count

      perform_login(merchants(:merchant_1))
      expect{post categories_path, params: category_hash}.must_differ "Product.count", 0
      expect(flash[:error]).must_include "Something happened"
    end 

  end 

  describe "new" do
    it "responds with success" do
      # Act
      perform_login(merchants(:merchant_1))
      get new_category_path

      # Assert
      must_respond_with :success
    end
  end

end
