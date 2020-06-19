class Merchant < ApplicationRecord
  validates :username, :email, :uid, :provider, presence: :true

  has_many :products
  has_many :order_items, through: :products

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    return merchant
  end

  # def self.find_order_items
  #   merchant = Merchant.find_by(id: session[:user_id])

  #   merchant.order_items
  # end

  def total_revenue

    total = 0

    if self.order_items.length == 0
      return total
    else
      self.order_items.each do |order_item|
        if order_item.fulfillment_status != "pending" && order_item.fulfillment_status != "cancelled"
          total += (order_item.price * order_item.quantity)
        end
      end
    end

    return total
  end

  # self.order_items.each do |oi|
  #   order_merchant = oi.product.merchant
  # end
end