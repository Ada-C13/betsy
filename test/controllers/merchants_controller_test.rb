require "test_helper"

describe MerchantsController do

  def setup
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited to use the mock authentication hash.
    # A request to /auth/provider will redirect immediately to /auth/provider/callback.
    OmniAuth.config.test_mode = true
  end

  before do
    # @merchant = Merchant.create(
    #   username: 'Leroy Jenkins',
    #   email: 'leroy@gmail.com',
    #   uid: 2,
    #   provider: "github"
    # )
    # @order = Order.create()
  end

  describe "create" do
    it "can be instantiated" do
      merchant = Merchant.find_by(username: "merchant_1")

      expect(merchant.nil?).must_equal false
    end

    it "creates a new merchant" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)

      must_redirect_to root_path

      Merchant.count.must_equal start_count + 1

      session[:user_id].must_equal Merchant.last.id
    end
  end

  describe "show" do

  end

  describe "login/authorize with github" do
    it "logs in an existing user and redirects to the root route" do
      start_count = Merchant.count

      merchant = merchants(:merchant_1)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

      get auth_callback_path(:github)

      must_redirect_to root_path

      session[:user_id].must_equal merchant.id

      User.count.must_equal start_count
    end
  end

end
