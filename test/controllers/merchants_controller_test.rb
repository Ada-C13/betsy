require "test_helper"

describe MerchantsController do
  describe "show" do
    it "succeeds for an existing merchant ID" do
      get merchants_path(merchants(:merchant_1))

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus merchant ID" do
      invalid_id_merchant = -1

      get merchant_path(invalid_id_merchant)

      must_respond_with :not_found
    end
  end

  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:merchant_1))
      must_respond_with :redirect
    end

    it "can login in a new merchant" do
      new_merchant = Merchant.new(uid: 1111, username: "testuser", provider: "github", email: "t@gmail.com")

      expect {
        logged_in_merchant = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
    end

    it "could not create new merchant " do
      invalid_merchant = Merchant.new(uid: nil, username: nil, provider: "github", email: "t@gmail.com")

      perform_login(invalid_merchant)
      invalid_merchant.valid?
      expect(invalid_merchant.errors.messages[:username]).must_equal ["can't be blank"]
      expect(flash[:error]).must_equal "Could not create new merchant account: #{invalid_merchant.errors.messages}"
      must_redirect_to root_path
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

  describe "Current merchant" do
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
