class Order < ApplicationRecord
  validate :order_has_to_have_at_least_one_order_item_to_be_placed, on: :update

  validates :email_address, presence: true, on: :update
  validates :mailing_address, presence: true, on: :update
  validates :name_on_credit_card, presence: true, on: :update
  validates :credit_card_number, presence: true, length: { is: 16 }, on: :update
  validates :credit_card_expiration, presence: true, on: :update
  validates :credit_card_CVV, presence: true, on: :update
  validates :billing_zip_code, presence: true, on: :update

  def order_has_to_have_at_least_one_order_item_to_be_placed
    if order_items.count == 0
      errors.add(:order_items, "can't place an order without any order items")
    end
  end

  has_many :order_items

  def calculate_order_total
    return order_items.map { |order_item| order_item.calculate_total }.sum
  end

  def set_status_of_order_items_to_paid
    order_items.each do |order_item|
      order_item.order_item_status = "paid"
      order_item.save
    end
  end

  def set_status_of_order_to_complete_if_order_items_are_shipped
    if order_items.all? { |order_item| order_item.order_item_status == "shipped" }
      self.order_status = "complete"
      self.save
    end
  end
end
