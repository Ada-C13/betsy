class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :name, presence: true
  validates :email, presence: true
  validates :cc_number, presence: true, numericality: { only_integer: true }, length: {is: 16 }
  validates :cc_exp, presence: true
  validates :mailing_address, presence: true
  validates :zipcode, presence: true, numericality: { only_integer: true}, length: { is: 5 }
  validates :cvv, presence: true, numericality: { only_integer: true }, length: { is: 3 }

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end
end
