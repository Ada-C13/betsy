require "test_helper"

describe MerchantsController do
  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:merchant_1))
      must_respond_with :redirect
    end

    it "can login in a new merchant" do
      new_merchant = Merchant.new(uid: "1111", username: "testuser", provider: "github", email: "testuser1@gmail.com")

      expect {
        logged_in_merchant = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "can logout as existing merchant" do
      # Arrnge
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
