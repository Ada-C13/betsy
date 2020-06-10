require "test_helper"


describe Merchant do
  let (:new_merchant) {merchants(:katherine) }


  describe "validations" do

    it "is valid when a merchant has a username and email" do
      expect(merchant.valid?).must_equal true 
    end

    it "is invalid without a username" do      
      merchant.username = nil
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :username
    end
    

    it "is invalid without an email" do
      merchant.email = nil
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
    end

  end



  describe "relationships" do
    it "has/responds to products" do
      expect(merchants.respond_to?(:products)).must_equal true
    end
  end

end
