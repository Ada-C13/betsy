class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :name, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: {scope: :provider}
end
