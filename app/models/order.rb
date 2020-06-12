class Order < ApplicationRecord

  has_many   :order_items, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled) # complete means shipped
  validates :status, presence: true, inclusion: {in: VALID_STATUS}

  def checkout_order!
    return false if self.status != "pending"
    return false if self.credit_card_num.nil? || self.credit_card_exp.empty? ||
                    self.credit_card_cvv.nil? || self.customer_email.empty?
    self.status = "paid"
    return self.save
  end

  def ship_order!
    return false if self.status != "paid"
    self.status = "complete"
    return self.save
  end

  def cancel_order!
    return false if self.status != "paid" # add a test here!
    self.status = "cancelled"
    return self.save
  end

  def total_cost
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end
  
  def self.by_merchant(merchant_id) # add test
    items = OrderItem.select { |item| item.product.merchant_id == merchant_id }
    orders = items.map { |item| item.order_id }
    return Order.select { |order| orders.include?(order.id) }
  end
  
end
