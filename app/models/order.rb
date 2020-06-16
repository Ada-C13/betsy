class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :cc_number, presence: true, numericality: { only_integer: true }, length: {is: 16 }, on: :update
  validates :cc_exp, presence: true
  validates :mailing_address, presence: true, on: :update
  validates :zipcode, presence: true, numericality: { only_integer: true}, length: { is: 5 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, length: { is: 3 }, on: :update

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end
end
