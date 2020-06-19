class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.by_order_id(id)
    order_items = OrderItem.all

    items_list = order_items.select do |item|
      item.order_id == id
    end

    return items_list
  end

  def total_per_item
    return self.quantity * self.product.price
  end

  def self.by_merchant(id)
    order_items = OrderItem.all
    order_items_per_merchat = []
    order_items.each do |item|
      if Product.find_by(id: item.product_id).merchant_id == id
        order_items_per_merchat << item
      end
    end
    return order_items_per_merchat
  end
end
