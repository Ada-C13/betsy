require "test_helper"

describe MerchantsController do

  describe "merchant_products" do
    it "succeeds when there are products in a merchant" do
      merchant_id = merchants(:merchant1).id
      get merchant_products_path(merchant_id)
      must_respond_with :success
    end

    it "succeeds when there are no products" do
      Product.destroy_all
      merchant_id = merchants(:merchant1).id
      get merchant_products_path(merchant_id)

      must_respond_with :success
    end

    describe "mock login" do
      it "logs in an existing merchant and redirects to the root route" do

        start_count = Merchant.count
        merchant = merchants(:merchant1)
        perform_login(merchant)
  
        must_redirect_to root_path
  
        session[:user_id].must_equal merchant.id
  
        expect(Merchant.count).must_equal start_count
      end

      it "can log in an existing merchant" do
        user = perform_login(merchants(:merchant1))
  
        must_respond_with :redirect
      end
  
      it "can log in/create a new merchant and redirects" do
        new_merchant = Merchant.new(uid: 11111, username: "someone", email: "someone@yahoo.com", provider: "github")
        
        expect {
          perform_login(new_merchant)
        }.must_change "Merchant.count", 1
       
        must_respond_with :redirect
      end

      it "redirects if given invalid merchant data" do
        new_merchant = Merchant.new(uid: nil, username: nil, email: "hi@yahoo.com", provider: "github")
        perform_login(new_merchant)
        must_redirect_to github_login_path
      end
    end

    describe "logout" do
      it "can logout an existing merchant" do
        # Arrange
        perform_login
  
        expect(session[:user_id]).wont_be_nil
  
        post logout_path, params: {}
  
        expect(session[:user_id]).must_be_nil
        must_redirect_to root_path
      end
  
      it "guest users on that route" do

      #TODO - this was in ada books? I think we need to to make sure guests dont have a logout option.... really not sure.
      end
    end
  end
end
