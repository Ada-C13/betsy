class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true, uniqueness: { scope: :merchant }
  validates :price, presence: true, numericality: { only_float: true, greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, presence: true
  validates :description, presence: true
  validates :photo, presence: true 
end
