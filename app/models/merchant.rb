class Merchant < ApplicationRecord

  has_many :products

  has_many :order_items, through: :products
  has_many :orders, through: :order_items

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, uniqueness: { scope: :provider}
  
  # helper method
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]

    return merchant
  end



  #returns all products belonging to this merchant
  # def self.all_products 
  #   return self.products.where(merchant_id: self.id)
  # end
  
end

