class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: %w(pending paid shipped), message: "Status must be pending, paid, or shipped"} 
  def order_submitted?
    status == "paid" || status == "shipped"
  end
  with_options if: :order_submitted? do |submitted|
    submitted.validates :name, presence: true
    submitted.validates :email, presence: true, 
      format: { with: /[a-z0-9\+\-_\.]+@[a-z\d\-]+\.[a-z]+\z/, message: "email is not valid" }
    submitted.validates :address, presence: true
    submitted.validates :cc_last_four, presence: true, 
      format: { with: /\d{4}/, message: "cc_last_four is not valid" }
    submitted.validates :cc_exp, presence: true
    submitted.validates :cc_cvv, presence: true, numericality: { only_integer: true }
  end

  def submit_order

  end
  def clear_cart
  end 
  def total_price
  end 
  def update_status
  end
  


end
