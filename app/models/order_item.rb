class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def subtotal
    return product.price * quantity
  end
end
