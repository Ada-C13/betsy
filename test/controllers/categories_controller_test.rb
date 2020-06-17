require "test_helper"

describe CategoriesController do
  describe "new action" do
    it 'can get the new category form path when logged in' do
      perform_login
      get new_category_path
      must_respond_with :success
    end

    it 'will get an error message when merchant is not logged in' do
      get new_category_path
      must_redirect_to root_path
      expect(flash[:danger]).must_equal "Must be logged in as a merchant."
    end
  end

  describe "create action" do
    describe "logged in merchant" do
      before do 
        perform_login
        @current_merchant = session[:merchant_id]

        @category_params = {
          category: {
            name: "new category",
            description: "this is a new category"
          }
        }
      end

      it 'can create a new category with correct info' do
        expect{ post categories_path, params: @category_params }.must_differ 'Category.count', 1
        category = Category.last

        expect( category.name ).must_equal @category_params[:category][:name]
        expect( category.description ).must_equal @category_params[:category][:description]
        must_redirect_to dashboard_merchant_path(@current_merchant)
        expect(flash[:success]).must_equal "Successfuly created #{category.name} category"
      end

      it 'can not create a new category if name is missing' do
        @category_params[:category][:name] = nil

        expect{ post categories_path, params: @category_params }.wont_differ 'Category.count'
        must_respond_with :bad_request 
        expect(flash[:warning]).must_equal "Unable to save category."
        expect(flash[:details]).must_equal ["Name can't be blank"]
      end
    end

    describe 'logged out guest' do
      it 'can not create a new category' do
        assert_no_difference("Category.count") do
          post categories_path, params: { name: "new category" }
        end
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end
    end
  end
end
