require "test_helper"

describe MerchantsController do

  describe "Logged in users" do
    before do 
      @merchant = merchants(:merchantaaa)
      @merchant4 = merchants(:merchantddd)
      perform_login(@merchant)
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
        get account_path(-1)
        expect(flash[:error]).must_equal  "You don't have access to that account!"
        must_redirect_to account_path(@merchant.id)
      end
    end

    describe "shop" do
      it "should return all products that belongs to one merchant" do
        get merchant_shop_path(@merchant.id)
        all_products_merchant = @merchant.products
        expect(all_products_merchant.length).must_equal 4
        must_respond_with :success
      end

      it "will return empty array if we dont have any product for specific merchant" do
        perform_login(@merchant4)
        get merchant_shop_path(@merchant4.id)
        all_products_merchant = @merchant4.products
        expect(all_products_merchant.length).must_equal 0
        must_respond_with :success
      end
    end

    describe "create(login as a merchant)" do
        let(:invalid_merchant) {
          Merchant.new(
            provider: "github",
            uid: "1234567",
            name: nil,
            email:"youknowwho@ada.org",
            avatar: "https://i.imgur.com/WSHmeuf.jpg"
          )
        }
        let(:valid_merchant) {
          Merchant.new(
            provider: "github",
            uid: "1234567",
            name: "youknowwho",
            email:"youknowwho@ada.org",
            avatar: "https://i.imgur.com/WSHmeuf.jpg"
            )
        }

      it "can log in" do
        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "can log in a new user" do
        put logout_path, params: {}
        expect{logged_in_user = perform_login(valid_merchant)}.must_change "Merchant.count", 1
        expect(Merchant.last.provider).must_equal valid_merchant[:provider]
        expect(Merchant.last.uid).must_equal valid_merchant[:uid]
        expect(Merchant.last.name).must_equal valid_merchant[:name]
        expect(Merchant.last.email).must_equal valid_merchant[:email]
        expect(Merchant.last.avatar).must_equal valid_merchant[:avatar]
        expect(flash[:notice]).must_equal "Logged in as a new merchant #{valid_merchant[:name].titleize}"
        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "can't create merchant if merchant data is invalid" do
        put logout_path, params: {}
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(invalid_merchant))
        get omniauth_callback_path(:github)
        expect(flash[:error]).must_equal "Could not create merchant account"
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
