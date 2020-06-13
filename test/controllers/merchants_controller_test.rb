require "test_helper"

describe MerchantsController do
  describe "login merchants#create" do
    it "can log in a new merchant through OAuth and increase Merchant count" do
      new_merchant = Merchant.new(username: "goblin", email: "goblin@goblins.net")

      expect {
        @logged_in_merchant = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      expect(session[:user_id]).must_equal @logged_in_merchant.id
      must_respond_with :redirect
    end

    it "can log in an existing merchant through OAuth" do
      expect {
        @existing_merchant = perform_login(merchants(:peaceful))
      }.wont_change "Merchant.count"

      expect(session[:user_id]).must_equal @existing_merchant.id
      must_respond_with :redirect
    end
  end

  describe "logout" do
    it "can log out a merchant" do
      # first merchant logged in and in session
      perform_login
      expect(session[:user_id]).wont_be_nil

      post logout_path
      expect(session[:user_id]).must_be_nil
      must_respond_with :redirect
    end
  end
end
