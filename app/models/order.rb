class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  with_options if: :order_submitted? do |submitted|
    submitted.validates :name, presence: true
    submitted.validates :email, presence: true
    submitted.validates :address, presence: true
    submitted.validates :cc_last_four, presence: true, 
      format: { with: /\d{4}/, message: "cc_last_four is not valid" }
    submitted.validates :cc_exp, presence: true
    submitted.validates :cc_cvv, presence: true, numericality: { only_integer: true }
  end
  validates :status, inclusion: { in: %w(pending paid shipped), message: "%{value} is not a valid status" }

  def order_submitted?
    status == "paid" || status == "shipped"
  end

end
