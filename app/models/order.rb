class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end
end
