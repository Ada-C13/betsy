class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items, dependent: :destroy
  # Suely: I assume order_items should be deleted if product is deleted
  # has_one_attached :photo

  validates :name, presence: true, uniqueness: { scope: :merchant_id, 
    message: "Merchant already has product of this name %{value} ." }
  validates :price, presence: true, numericality: { greater_than: 0,
    message: "Price of product must be a number greater than $0" }
    
end
