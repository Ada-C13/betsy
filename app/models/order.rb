class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end

  def self.search(search)
    if search
      return Order.find_by(id: search[:id], email: search[:email])
    end
  end
end
