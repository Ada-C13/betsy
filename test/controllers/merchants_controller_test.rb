require "test_helper"

describe MerchantsController do

  describe "auth_callback" do
    it "logs in an existing merchant" do
      start_count = Merchant.count
      merchant = merchants(:angela)
    
      perform_login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal  merchant.id
    
      # Should *not* have created a new merchant
      Merchant.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 2222, name: "test_user", email: "test@user.com")
    
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)
    
      must_redirect_to root_path
    
      # Should have created a new merchant
      Merchant.count.must_equal start_count + 1
    
      # The new merchant's ID should be set in the session
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "redirects to the login route if given invalid user data" do
    end
  end
  
end
