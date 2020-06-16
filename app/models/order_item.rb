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

end
