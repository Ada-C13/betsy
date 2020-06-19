class Order < ApplicationRecord
  has_many :order_items
  before_save :default_status

  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :name, presence: true, on: :update
  validates :credit_card, presence: true, numericality: true, length: { minimum: 4 }, on: :update
  validates :credit_card_exp, presence: true, on: :update

  def default_status
    self.status ||= "pending"
  end

  def order_purchase
    # Reduces the number of inventory for each product
    self.order_items.each do |item|
      product = item.product
      product.inventory -= (item.quantity)
      product.save!
    end

    # Changes the order state from "pending" to "paid"
    self.status = "paid"
    self.save
  end

  def order_cost
    @sum = 0
    self.order_items.each do |item|
      @sum += item.total_per_item
    end
    return @sum
  end

  def cancel_order_inventory
    self.order_items.each do |item|
      product = item.product
      product.inventory += (item.quantity)
      product.save!
    end

    # Changes the order state to cancelled
    self.status = "cancelled"
    self.save
  end

end
