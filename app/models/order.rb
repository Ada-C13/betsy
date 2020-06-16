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
    # checking if stock is still available
    self.order_items.each do |item|
      return false if item.quantity > item.product.stock
    end
    # begin transaction
    self.order_items.each do |item|
      item.product.stock -= item.quantity
      item.product.save
    end
    self.status = "paid"
    result = self.save
    # end transaction
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
  
  # TODO: move to merchant / remove because merchant.orders 
  # already returns all orders belonging to the merchant
  # def self.by_merchant(merchant_id)
  #   merchant = Merchant.find_by(id: merchant_id)
  #   return [] if merchant.nil?
  #   return merchant.orders
  # end
  
end
