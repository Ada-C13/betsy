class Merchant < ApplicationRecord
  validates :username, :email, :uid, :provider, presence: :true

  has_many :products
  has_many :orders

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]

    return merchant
  end

  # def self.total_revenue
  #   merchant = Merchant.find_by(id: session[:user_id], provider: "github")
  #   total = 0

  #   if merchant.orders.length == 0
  #     return total
  #   else
  #     merchant.orders.each do |order|
  #       order.order_items.each do |order_item|
  #         total += (order_item.price * order_item.quantity)
  #       end
  #     end
  #   end

  #   return total
  # end

  # self.order_items.each do |oi|
  #   order_merchant = oi.product.merchant
  # end
end