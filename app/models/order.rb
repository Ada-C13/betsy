class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :update 
  validates :cc_number, presence: true, numericality: { only_integer: true }, length: {is: 16 }, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :mailing_address, presence: true, on: :update
  validates :zipcode, presence: true, numericality: { only_integer: true}, length: { is: 5 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, length: { is: 3 }, on: :update

  validate :valid_expiration_date, on: :update

  def total
    return order_items.map{ |item| item.subtotal}.sum
  end

  def self.search(search)
    if search
      return Order.find_by(id: search[:id], email: search[:email])
    end
  end
  
  def find_merchants_ids
    merchant_ids = []
    self.products.each do |product|
      merchant_ids << product.merchant.id
    end
    return merchant_ids
  end

  def valid_expiration_date
    if self.cc_exp.nil?
      errors.add(:cc_exp, "can't be nil")
    elsif Date.today > self.cc_exp
      errors.add(:cc_exp, "can't be in the past")
    end
  end
end
