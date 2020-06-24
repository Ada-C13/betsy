class OrderItem < ApplicationRecord
  validates :product_id, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.cart_count(session)
    count = 0

    session[:cart].each do |product|
      count += product["quantity"]
    end

    return count 
  end
end
