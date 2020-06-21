class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: true, presence: true

  # method to create new merchant using github login
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash[:info][:username]
    merchant.email = auth_hash[:info][:email]
    return merchant
  end

  def revenue_by_status(status)
    revenue_by_status = 0
    orders_of_a_status = self.order_status(status)

    orders_of_a_status.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          product = Product.find_by(id: item.product_id)
          price = product.price
          revenue_by_status += price
        end
      end
    end

    return revenue_by_status
  end

  def total_revenue
    revenue = 0
    orders = self.all_orders

    orders.each do |order|
      if (order.status != "cancelled") && (order.status != "pending")
        order.orderitems.each do |item|
          if item.product.merchant_id == self.id
            product = Product.find_by(id: item.product_id)
            price = product.price
            revenue += price
          end
        end
      end
    end

    return revenue
  end

  def all_orders
    # finds merchant's orders and checks if they can be marked complete
    merchant_orders = []
    
    Order.all.each do |order|
      order.orderitems.each do |item|
        if item.product.merchant_id == self.id
          order = Order.find_by(id: item.order_id)

          if order.orderitems.find_by(shipped: false).nil?
            order.mark_as_complete!
          end

          merchant_orders << order
          break
        end
      end
    end

    return merchant_orders
  end

  def order_status(status)
    orders = self.all_orders
    status_orders = []
    
    orders.each do |order|
      if order.status == status
        status_orders << order
      end
    end

    return status_orders
  end
end