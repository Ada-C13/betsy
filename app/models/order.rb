class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  # validates :name, presence: true
  # validates :email, presence: true
  # validates :address, presence: true
  # validates :cc_last_four, presence: true, numericality: { only_integer: true }
  # validates :cc_exp, presence: true
  # validates :cc_cvv, presence: true, numericality: { only_integer: true }
  validates :status, inclusion: { in: %w(pending paid shipped), message: "%{value} is not a valid status" } 

end
