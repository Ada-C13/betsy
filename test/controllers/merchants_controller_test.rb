require "test_helper"

describe MerchantsController do
  

  describe "login" do
    it "can login in a new merchant" do
      new_merchant = Merchant.new(uid: "2000", username: "hobo", provider: "github", email: "hobo@adadevelopers.org")

      expect {
        logged_in_merchant = perform_login(new_merchant)
      }.must_change "Merchant.count", 1

      must_respond_with :redirect
    end

    it "can log in an existing merchant" do
      merchant = perform_login(merchants(:angela))
      must_respond_with :redirect
    end
    
    it "could not create new merchant " do
      invalid_merchant = Merchant.new(uid: nil, username: nil, provider: "github", email: "something.com")

      perform_login(invalid_merchant)
      invalid_merchant.valid?
      expect(invalid_merchant.errors.messages[:username]).must_equal ["can't be blank"]
      expect(flash[:error]).must_equal "Could not create new merchant account: #{invalid_merchant.errors.messages}"
      must_redirect_to root_path
    end
  end


    
  describe "dashboard actions" do
    describe "with correct merchant logged in" do
      before do
        perform_login
        @correct_id = session[:merchant_id]
      end

      it "responds with success when retrieving dashboard" do
        get dashboard_merchant_url(@correct_id)
        must_respond_with :success
      end

      it "responds with success when retrieving merchant orders" do
        get manage_orders_url(@correct_id)
        must_respond_with :success
      end

      it "responds with success when retrieving merchant products" do
        get manage_products_url(@correct_id)
        must_respond_with :success
      end
    end

    describe "with incorrect merchant logged in" do
      before do
        perform_login
        @correct_id = session[:merchant_id]
        @incorrect_id = session[:merchant_id] + 1
      end

      it "responds with redirect when retrieving dashboard" do
        get dashboard_merchant_url(@incorrect_id)
        must_respond_with :redirect
        must_redirect_to dashboard_merchant_url(@correct_id)
        expect(flash[:warning]).must_equal "Tried to access a resource that isn't yours."
      end

      it "responds with redirect when retrieving merchant orders" do
        get manage_orders_url(@incorrect_id)
        must_respond_with :redirect
        must_redirect_to dashboard_merchant_url(@correct_id)
        expect(flash[:warning]).must_equal "Tried to access a resource that isn't yours."
      end

      it "responds with redirect when retrieving merchant products" do
        get manage_products_url(@incorrect_id)
        must_respond_with :redirect
        must_redirect_to dashboard_merchant_url(@correct_id)
        expect(flash[:warning]).must_equal "Tried to access a resource that isn't yours."
      end
    end

    describe "with no merchant logged in" do
      before do
        perform_login
        perform_logout
      end

      it "responds with danger when retrieving dashboard" do
        get dashboard_merchant_url
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end

      it "responds with danger when retrieving merchant orders" do
        get manage_orders_url
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end

      it "responds with danger when retrieving merchant products" do
        get manage_products_url
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:danger]).must_equal "Must be logged in as a merchant."
      end
    end

  end
  

  describe "logout" do
    it "can logout as existing merchant" do
    
      perform_login

      expect(session[:merchant_id]).wont_be_nil

      perform_logout
      expect(session[:merchant_id]).must_be_nil
      must_redirect_to root_path
    end
  end
  
end
