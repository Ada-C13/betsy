class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :name, presence: true, if: :order_submitted?
  validates :email, presence: true, if: :order_submitted?
  validates :address, presence: true, if: :order_submitted?
  validates :cc_last_four, presence: true, if: :order_submitted?, numericality: { only_integer: true }
  validates :cc_exp, presence: true, if: :order_submitted?
  validates :cc_cvv, presence: true, if: :order_submitted?, numericality: { only_integer: true }
  validates :status, inclusion: { in: %w(pending paid shipped), message: "%{value} is not a valid status" }

  def order_submitted?
    status == "paid" || status == "shipped"
  end

end
