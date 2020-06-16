class Order < ApplicationRecord

  has_many   :order_items, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled)
  validates :status, presence: true, inclusion: {in: VALID_STATUS}
  validates :name, presence: true, on: :update
  validates :credit_card_num, presence: true, on: :update
  validates :credit_card_exp, presence: true, on: :update
  validates :credit_card_cvv, presence: true, on: :update
  validates :customer_email, presence: true, on: :update

  def checkout_order!
    return false if self.status != "pending"
    return false if self.name.nil? || self.credit_card_num.nil? ||
                    self.credit_card_exp.nil? || self.credit_card_cvv.nil? ||
                    self.customer_email.nil?  || self.address.nil? ||
                    self.city.nil? || self.state.nil? || self.zip.nil?
    self.status = "paid"
    return self.save
  end

  def ship_order!
    return false if self.status != "paid"
    self.status = "complete"
    return self.save
  end

  def cancel_order!
    return false if self.status != "paid" 
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
  
  def self.by_merchant(merchant_id) # TODO move to merchant
    merchant = Merchant.find_by(id: merchant_id)
    return [] if merchant.nil?
    return merchant.orders
  end
  
end
