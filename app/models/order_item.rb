class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :product
  validates  :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    return 0 if !self.product
    return self.quantity * self.product.price
  end

  def self.add_item(order_id, product_id, quantity) # TODO add test for this method
    order = Order.find_by(id: order_id)
    return "Order not found" if !order
    product = Product.find_by(id: product_id)
    return "Product not found" if !product
    order_item = OrderItem.find_by(order_id: order_id, product_id: product_id)
    if !order_item
      return "Quantity not available in stock" if quantity > product.stock
      order_item = OrderItem.new(order_id: order_id, product_id: product_id, quantity: quantity)
    else
      return "Quantity not available in stock" if quantity + order_item.quantity > product.stock
      order_item.quantity += quantity
    end
    if order_item.save
      return nil
    else
      return "Error saving the order item"
    end
  end

  def update_item(quantity) # TODO add test for this method
    return "Order cannot be changed" if self.order.status != "pending"
    return "Product not found" if !self.product
    return "Quantity not available in stock" if quantity > self.product.stock
    self.quantity = quantity
    if self.save
      return nil
    else
      return "Error updating the order item"
    end
  end

  def remove_item # TODO add test for this method
    return "Order cannot be changed" if self.order.status != "pending"
    if self.destroy
      return nil
    else
      return "Error removing the order item"
    end
  end

end
