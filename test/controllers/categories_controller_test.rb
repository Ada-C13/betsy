require "test_helper"

describe CategoriesController do
  describe "unauthenticated" do
    describe "index" do
      it "should respond with success" do
        get categories_path

        must_respond_with :success
      end

      it "doesn't break if no categories" do
        Category.destroy_all
        get categories_path

        must_respond_with :success
      end
    end
  end

  describe "authenticated user" do
    before do 
      login(users(:user1))
    end

    describe "new" do
      it "gets the new category path" do
        get new_category_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new category" do
        new_category_params = {
          category: {
            name: "miscellaneous"
          }
        }
        
        expect{post categories_path, params: new_category_params}.must_change "Category.count", 1

        new_category = Category.find_by(name: new_category_params[:category][:name])

        expect(new_category.name).must_equal new_category_params[:category][:name]
        expect(flash.now[:success]).must_equal "#{new_category.name} was successfully added! 😄"
        must_redirect_to categories_path
      end

      it "doesn't create a new category when name is nil" do
        new_category_params = {
          category: {
            name: nil
          }
        }

        expect{post categories_path, params: new_category_params}.wont_change "Category.count"
        expect(flash.now[:error]).must_equal "A problem occurred: Could not update '#{new_category_params[:category][:name]}'"
        assert_template :new
      end

      it "doesn't create a new category when name is an empty string" do
        new_category_params = {
          category: {
            name: ""
          }
        }

        expect{post categories_path, params: new_category_params}.wont_change "Category.count"
        expect(flash.now[:error]).must_equal "A problem occurred: Could not update '#{new_category_params[:category][:name]}'"
        assert_template :new
      end
    end

    describe "update" do
      it "updates an existing category" do
        category = categories(:fossils)
        category_name = category.name

        updated_category_params = {
          category: {
            name: "bones"
          }
        }

        expect {patch category_path(category.id), params: updated_category_params}.wont_change "Category.count"

        updated_category = Category.find_by(id: category.id)
        expect(updated_category.name).must_equal updated_category_params[:category][:name]
        expect(flash.now[:success]).must_equal "#{updated_category.name} was successfully edited! 😄"
      end

      it "will not update existing category whith invalid params (nil)" do
        category = categories(:fossils)
        category_name = category.name

        updated_category_params = {
          category: {
            name: nil
          }
        }

        expect {patch category_path(category.id), params: updated_category_params}.wont_change "Category.count"

        updated_category = Category.find_by(id: category.id)
        assert_template :edit
        expect(flash.now[:error]).must_equal "The category was not successfully edited :("
      end

      it "will not update existing category whith invalid params (empty)" do
        category = categories(:fossils)
        category_name = category.name

        updated_category_params = {
          category: {
            name: ""
          }
        }

        expect {patch category_path(category.id), params: updated_category_params}.wont_change "Category.count"

        updated_category = Category.find_by(id: category.id)
        assert_template :edit
        expect(flash.now[:error]).must_equal "The category was not successfully edited :("
      end
    end
  end
end
