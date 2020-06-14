require "test_helper"

describe MerchantsController do
  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:merchant1))
      starting_count = Merchant.count

      must_respond_with :redirect
      expect Merchant.count.must_equal starting_count
    end
    
    it "can log in a new merchant" do
      new_merchant = Merchant.new(uid: "6789", username: "Anto", provider: "github", email: "anto@blahblahblah.org")
      starting_count = Merchant.count
      expect {
        logged_in_user = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merchant))
      get auth_callback_path(:github)
      
      
      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "an logout an existing user" do
      perform_login

      expect(session[:merchant_id]).wont_be_nil

      post logout_path, params: {}

      post logout_path

      expect(session[:merchant_id]).must_be_nil
    end

  end

  describe "show" do 
    it "responds with success when showing an existing valid merchant" do 
      merchant = perform_login(merchants(:merchant1))

      get merchant_path(merchant.id)

      must_respond_with :success
    end

    it "redirects to products path when an invalid merchant id is provided" do 
      get merchant_path(-1)

      must_respond_with :redirect 
      must_redirect_to root_path 
    end
  end
end