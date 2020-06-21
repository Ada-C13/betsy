class Orderitem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0}
  # when should we call shipped validation below?
  validates :shipped, inclusion: { in: [true, false], message: "shipped status : must be true or false" }

  # validate :enough_stock_2?(quantity), on: :update
  # validate :not_retired?, on: :update

  def subtotal
    subtotal = (self.quantity) * (self.product.price)
    return subtotal.round(2)
  end

  def mark_item_shipped!
    self.update_attribute(:shipped, true)
  end

  # private

  def enough_stock?(quantity)
    if quantity > self.product.stock
      errors.add(:quantity, "order exceeds in-stock inventory")
      errors.add(:quantity, "#{quantity}")
      # raise
      return false
    else
      return true
    end
  end

  def not_retired?
    if product && product.retired
      errors.add(:product_id, "#{product.name} is no longer available")
      return false
    else
      return true
    end
  end
end
