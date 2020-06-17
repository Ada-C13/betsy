class OrderItem < ApplicationRecord
  validates :order_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def total
    product = Product.find_by(id: self.product_id)
    return self.quantity * product.price
  end

  def remove_from_cart
    self.product.return_to_inventory(self.quantity)
    return
  end

  def mark_cancelled
    self.complete = nil
    self.product.return_to_inventory(self.quantity)
    self.save

    self.order.status_check
  end

  def mark_complete
    self.complete = true
    self.save

    self.order.status_check
  end

  def self.cart_count(session)
    count = 0

    session[:cart].each do |product|
      count += product["quantity"]
    end

    return count 
  end

  def self.exists?(order_id, product_id)
    exists = OrderItem.where(order_id: order_id, product_id: product_id)  
    
    if exists.empty?
      return false
    else
      return exists[0]
    end
  end


end
