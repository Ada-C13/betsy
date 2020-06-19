require "test_helper"


describe Merchant do
  let (:new_merchant) {merchants(:katherine) }


  describe "validations" do

    it "is valid when a merchant has a username and email" do
      expect(new_merchant.valid?).must_equal true 
    end

    it "is invalid without a username" do      
      new_merchant.username = nil
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end
    

    it "is invalid without an email" do
      new_merchant.email = nil
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end

  end


  describe "relationships" do
    it "has/responds to products" do
      expect(new_merchant.respond_to?(:products)).must_equal true
    end
  end

end
