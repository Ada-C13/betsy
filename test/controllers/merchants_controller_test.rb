require "test_helper"

describe MerchantsController do

  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:angela))
      must_respond_with :redirect
    end

    it "can login in a new merchant" do
      new_merchant = Merchant.new(uid: "2244", username: "angie", provider: "github", email: "angela@adadevelopers.org")

      expect {
        logged_in_merchant = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "can logout as existing merchant" do
      # Arrange
      perform_login

      expect(session[:merchant_id]).wont_be_nil

      delete logout_path, params: {}

      expect(session[:merchant_id]).must_be_nil
      must_redirect_to root_path
    end
  end

  describe "going to the detail page of the current merchant" do
    it "responds with success if a merchant is logged in" do
      perform_login
    
      get current_merchant_path

      must_respond_with :success
    end

    it "responds with a redirect if no merchant is logged in" do
      get current_merchant_path
      must_respond_with :redirect
    end
  end
  
end
