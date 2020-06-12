class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :name, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: {scope: :provider}

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash["uid"]
    merchant.provider = auth_hash["provider"]
    merchant.name = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the merchant has not been saved.
    # We'll do the saving outside of this method
    return merchant
  end
end
