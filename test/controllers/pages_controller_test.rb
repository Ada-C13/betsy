require "test_helper"

describe PagesController do
  it "must get home" do
    get pages_home_url
    must_respond_with :success
  end

  describe "search" do
    it "shows search results when not blank field" do
      search = {
        "search": "bottom"
      }

      get search_path, params: search

      must_respond_with :success
    end
    
    it "shows error message if blank search" do
      search = {
        "search": ""
      }

      get search_path, params: search
      
      expect(flash[:error]).must_equal "Empty field!"
      must_respond_with :redirect
      must_redirect_to frontpage_path
    end
  end
end
