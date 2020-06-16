class Product < ApplicationRecord
  has_and_belongs_to_many :categories

  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true 
  validates :title, uniqueness: { case_sensitive: false}

  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validates :stock, presence: true
  validates :stock, numericality: { greater_than: -1 }
end
