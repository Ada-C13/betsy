class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :name, presence: true
  validates :credit_card, presence: true, length: { is: 16 }
  validates :status, presence: true, inclusion: { in: ["paid", "complete", "canceled"] }


  def self.order_total(order_items) 
    total = 0.0
    order_items.each do |prod, val|
      total += (prod.price * val.to_i)
    end 
    return total + (total * (0.1))
  end 

  def self.restock_canceled_items(order)
    order.order_items.each do |item|
      product = Product.find_by(id: item.product_id)
      if !product.update(qty: (item.qty + product.qty))
        return false
      end 
    end 
    return true
  end 

  def self.total(order_id) 
    order = Order.find_by(id: order_id)
    total = 0.0
    order.order_items.each do |item| 
      product = Product.find_by(id: item.product_id)
      total += (product.price * item.qty.to_i)
    end 
    return total + (total * (0.1))
  end   

end
