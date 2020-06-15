class Merchant < ApplicationRecord
  has_many :products
  validates :uid, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash["uid"]
    merchant.provider = auth_hash["provider"]
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    #user has not been saved, will be saved outside of this method
    return merchant
  end


  def total_revenue
    merchant_products = self.products 
    total_revenue = 0.0

    merchant_products.each do |product|
      product.order_items.each do |item|
        if item.order.status == "cancelled"
          next
        end
        
        total_revenue += item.quantity * item.product.price
      end 
    end

    return total_revenue
  end

  def revenue_for(status)
    merchant_products = self.products 
    total_revenue = 0.0

    merchant_products.each do |product|
      product.order_items.each do |item|
        if item.order.status == status
          total_revenue += item.quantity * item.product.price
        end
      end
    end

    return total_revenue
  end

  def number_of_orders_for(status)
    orders = []

    merchant_products = self.products 
    merchant_products.each do |product|
      product.order_items.each do |item|
        if item.order.status == status
          orders << item.order_id
        end
      end
    end

    return orders.uniq.length
  end

  def existing_order_items_by_merchant
    merchant_products = self.products
    existing_items = [] 
    merchant_products.each do |product|
      product.order_items.each do |item|
        existing_items << item
      end
    end
    return existing_items
  end
end
