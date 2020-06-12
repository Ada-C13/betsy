require "test_helper"

describe MerchantsController do

  describe "login" do
    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:angela))
      must_respond_with :redirect
    end

    it "can login in a new merchant" do
      new_merchant = Merchant.new(uid: "2000", username: "hobo", provider: "github", email: "hobo@adadevelopers.org")

      expect {
        logged_in_merchant = perform_login(new_merchant)
        #perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
    end
  end

  describe "dashboard" do
    it "responds with success if correct merchant is logged in" do
      
    end

    it "responds with redirect if no merchant is logged in" do
      
    end

    it "responds with redirect if incorrect merchant is logged in" do
      
    end
    
  end

  describe "manage orders" do
    it "responds with success if correct merchant is logged in" do
      
    end
    
    it "responds with redirect if no merchant is logged in" do
      
    end

    it "responds with redirect if incorrect merchant is logged in" do
      
    end
  end

  describe "manage products" do
    it "responds with success if correct merchant is logged in" do
      
    end
    
    it "responds with redirect if no merchant is logged in" do
      
    end

    it "responds with redirect if incorrect merchant is logged in" do
      
    end
  end

  describe "logout" do
    it "can logout as existing merchant" do
      # Arrange
      perform_login

      expect(session[:merchant_id]).wont_be_nil

      perform_logout

      expect(session[:merchant_id]).must_be_nil
      must_redirect_to root_path
    end
  end
  
end
