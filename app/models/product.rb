class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :merchant_id, 
    message: "%{value} has already been taken." }
  validates :price, presence: true, numericality: { greater_than: 0,
    message: "must be a number greater than $0" }
  validates :stock, presence: true, numericality: { greater_than: 0 }
end
