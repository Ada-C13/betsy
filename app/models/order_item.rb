class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :name, presence: true
  validates :quantity, presence: true

  def check_product_inventory
    incoming_quantity = self.quantity
    matching_product = Product.find_by(id: self.product_id)

    return false if matching_product.status == false
    return false if incoming_quantity == nil || incoming_quantity == 0

    matching_product.inventory >= incoming_quantity ? true : false
  end

  def update_product_inventory(incoming_quantity)
    matching_product = Product.find_by(id: self.product_id)
    
    matching_product.inventory >= incoming_quantity.to_i ? true : false
  end

  def check_order_item_existence(order_id)
    order = Order.find_by(id: order_id)
    matching_item = order.order_items.find_by(product_id: self.product_id)

    if matching_item
      matching_item.quantity += self.quantity
      matching_item.save
    else
      self.save
    end
  end

  def reduce_inventory
    matching_product = Product.find_by(id: self.product_id)

    matching_product.inventory -= self.quantity
    matching_product.save
  end

  def add_inventory
    matching_product = Product.find_by(id: self.product_id)

    matching_product.inventory += self.quantity
    matching_product.save
  end
end
