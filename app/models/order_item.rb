class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    return self.quantity * self.product.price
  end

end
