class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_and_belongs_to_many :categories
  has_many :reviews

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}
  validates :inventory, presence: true, numericality: {only_integer: true} 
end