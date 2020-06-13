require "test_helper"

describe MerchantsController do

  describe "Logged in users" do
    before do 
      @merchant = perform_login
    end

    describe "index" do 
      it "responds with success when there are many merchants (without logging in)" do
        # Arrange (we have 4 merchants in the fixtures)
        num_of_merchants = Merchant.all.size
        # Act
        get merchants_path
        # Assert
        must_respond_with :success
        expect(num_of_merchants).must_equal 4
      end

      it "responds with success when there are no merchants (without logging in)" do
        # Arrange
        Merchant.destroy_all
        num_of_merchants = Merchant.all.size
        # Act
        get merchants_path
        # Assert
        must_respond_with :success
        expect(num_of_merchants).must_equal 0
      end
    end

    describe "account" do
      it "returns 200 for a logged-in user" do
        get account_path(@merchant.id)
        must_respond_with :success
      end

      it "redirect back to account if trying to access other merchant's account" do 
        other_merchant = Merchant.last
        get account_path(other_merchant.id)
        must_redirect_to account_path(@merchant.id)
        expect(flash[:error]).must_equal  "You don't have access to that account!"
      end

      it "redirect back to account if trying to access a not existed account" do
        get account_path(1000000000) # merchant 1000000000 doesn't exist
        must_redirect_to account_path(@merchant.id)
        expect(flash[:error]).must_equal  "You don't have access to that account!"
      end
    end

    describe "create(login as a merchant)" do
      it "can log in" do
        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "can log in a new user" do
        put logout_path, params: {}

        new_merchant = Merchant.new(uid:"932410", name: "youknowwho", provider: "github", email: "youknowwho@ada.org")

        expect{logged_in_user = perform_login(new_merchant)}.must_change "Merchant.count", 1
  
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "logout" do
      it "can logout an existing user" do
        put logout_path, params: {}

        expect(session[:merchant_id]).must_be_nil
        must_redirect_to root_path
      end
    end
  end


  describe "Guest users" do 
    describe "index" do 
      it "responds with success when there are many merchants (without logging in)" do
        # Arrange (we have 4 merchants in the fixtures)
        num_of_merchants = Merchant.all.size
        # Act
        get merchants_path
        # Assert
        must_respond_with :success
        expect(num_of_merchants).must_equal 4
      end

      it "responds with success when there are no merchants (without logging in)" do
        # Arrange
        Merchant.destroy_all
        num_of_merchants = Merchant.all.size
        # Act
        get merchants_path
        # Assert
        must_respond_with :success
        expect(num_of_merchants).must_equal 0
      end
    end

    describe "account" do
      it "redirect to root if trying to access other merchant's account" do 
        other_merchant = Merchant.last
        get account_path(other_merchant.id)
        must_redirect_to root_path
        expect(flash[:error]).must_equal "You must be logged in to do that!"
      end

      it "redirect to root if trying to access a not existed account" do
        get account_path(1000000000) # merchant 1000000000 doesn't exist
        must_redirect_to root_path
        expect(flash[:error]).must_equal "You must be logged in to do that!"
      end
    end
  end
end
