class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end

  def find_merchants_ids
    merchant_ids = []
    self.products.each do |product|
      merchant_ids << product.merchant.id
    end
    return merchant_ids
  end
end
