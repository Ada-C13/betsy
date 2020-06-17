class OrderItem < ApplicationRecord
  VALID_STATUSES = ["pending", "paid", "shipped", "cancelled"] 
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: VALID_STATUSES, message: "Not a valid status" }

  def ship
    self.status = "shipped"
    self.save 
  end

  def destock
    if self.product.stock > self.quantity
      self.product.destock(self.quantity)
      self.status = "paid"
      self.save
      return true
    else
      errors.add(:status, "#{self.product.name} is now out of stock!")
      return false
    end
  end

  def restock
    if self.status == "shipped"
      errors.add(:status, "This item is already shipped")
      return false
    end
    self.status = "cancelled"
    self.save
    self.product.restock(self.quantity)
    return true
  end



end
