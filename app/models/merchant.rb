class Merchant < ApplicationRecord
  has_many :products 

  def self.create_merchant_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash["uid"]
    merchant.provider = auth_hash["provider"]
    merchant.username = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]

    return merchant 
  end 
end
