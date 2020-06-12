require "test_helper"

describe MerchantsController do
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

  end

  describe "create(login as a merchant)" do
  end

  describe "logout" do

  end
end
