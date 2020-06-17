class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :product
  validates  :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    return self.product ? self.quantity * self.product.price : 0
  end

  def self.add_item(order_id, product_id, quantity)
    order = Order.find_by(id: order_id)
    return "Order not found" if !order
    return "Order cannot be changed" if order.status != "pending"
    product = Product.find_by(id: product_id)
    return "Product not found" if !product
    return "Product is retired" if !product.active
    return "Invalid quantity" if !quantity || quantity < 1
    order_item = OrderItem.find_by(
      order_id: order_id,
      product_id: product_id
    )
    if !order_item
      return "Quantity not available in stock" if quantity > product.stock
      order_item = OrderItem.new(
        order_id: order_id,
        product_id: product_id,
        quantity: quantity
      )
    else
      return "Quantity not available in stock" if quantity + order_item.quantity > product.stock
      order_item.quantity += quantity
    end
    return order_item.save ? nil : "Error saving the order item"
  end

  def update_item(quantity)
    return "Order cannot be changed" if self.order.status != "pending"
    return "Product not found" if !self.product
    return "Product is retired" if !product.active
    return "Invalid quantity" if !quantity || quantity < 1
    return "Quantity not available in stock" if quantity > self.product.stock
    self.quantity = quantity
    return self.save ? nil : "Error updating the order item"
  end

  def remove_item
    return "Order cannot be changed" if self.order.status != "pending"
    return self.destroy ? nil : "Error removing the order item"
  end

end
