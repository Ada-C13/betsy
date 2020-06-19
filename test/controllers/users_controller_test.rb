require "test_helper"

describe UsersController do

  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do

      start_count = User.count

      user = users(:grace)

      perform_login(user)

      must_redirect_to root_path

      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal user.id

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count

      user = User.new(uid: 123456, provider: 'github')

      perform_login(user)

      must_redirect_to root_path


      session[:user_id].must_equal User.last.id


      User.count.must_equal (start_count + 1)

    end

    it "redirects to the root path if given invalid user data" do
      start_count = User.count

      user = User.new(uid: 12345, provider: 'github')
      
      perform_login(user)

      must_redirect_to root_path

      User.count.must_equal start_count
    end

  end

  describe "index" do
    it "gets index" do
      get "/users"
      must_respond_with :success
    end
  end

  describe "show" do
    it "will get show for valid ids" do
      user = users(:grace)
      get user_path(user.id)
      must_respond_with :success
    end
    it "will respond with not_found for invalid id" do
      get user_path(-1)
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    before do
      user = users(:grace)
      perform_login(user)
    end
    it "clears session and redirect to root path" do
      delete logout_path
      session[:user_id].must_equal nil
      must_redirect_to root_path
    end
  end

  describe "my account" do
    it "responds with success if logged in" do
      user = users(:grace)
      perform_login(user)
      get myaccount_path
      must_respond_with :success
    end

    it "returns error if not logged in" do 
      delete logout_path
      get myaccount_path

      # user = users(:grace)
      # user.reload
      # expect(user).must_be_nil
      expect(flash[:error]).must_equal "You must be logged in to see this page"
      must_redirect_to root_path
    end
  end

  describe "my orders" do
    it "responds with succes if logged in" do
      user = users(:grace)
      perform_login(user)
      get myorders_path
      must_respond_with :success
    end

    it "responds with succes if logged in and adding filter to path" do
      user = users(:grace)
      perform_login(user)
      get myorders_path, params: {filter: "sucess"}
      must_respond_with :success
    end


    it "returns error if not logged in" do 
      delete logout_path
      get myorders_path
      expect(flash[:error]).must_equal "You must be logged in to see this page"
      must_redirect_to root_path
    end
  end
  
end
