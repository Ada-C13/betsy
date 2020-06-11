class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w(pending paid shipped), message: "%{value} is not a valid status" }

end
