class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems

  validates :status, presence: true, inclusion: { 
    in: %w(pending paid complete cancelled),
    message: "%{value} is not a valid status" 
  }

  validates :orderitems, length: { minimum: 1, message: "Your cart is empty" }, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { minimum: 4 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :zip, presence: true, numericality: { only_integer: true }, on: :update

  def cancel_order
    # TODO: Testing - Diana
    # return_stock
    self.return_stock

    # delete order items from this order
    self.orderitems.destroy_all

    # mark order :status as cancelled
    self.update_attribute(:status, "cancelled")
  end

  def reduce_stock
    self.orderitems.each do |orderitem|
      orderitem.product.stock -= orderitem.quantity
      orderitem.product.save!
    end
  end

  def return_stock
    self.orderitems.each do |orderitem|
      if !orderitem.product.retired
        orderitem.product.stock += orderitem.quantity
        orderitem.product.save!
      end
    end
  end

  def total
    total_cost = 0

    self.orderitems.each do |orderitem|
      total_cost += orderitem.subtotal
    end

    return total_cost
  end

  def mark_as_complete!
    if self.status == "paid" && self.orderitems.find_by(shipped: false).nil?
      self.update_attribute(:status, "complete")
    end
  end

  def change_to_paid!
    self.status = "paid"

    if !self.save
      return false
    else
      return true
    end
  end

  def checkout
    result = self.change_to_paid!

    if !result
      return false
    end

    self.reduce_stock

    return true
  end
end
