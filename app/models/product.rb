class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: { scope: :merchant_id, 
    message: "Merchant already has product of this name %{value} ." }
  validates :price, presence: true, numericality: { greater_than: 0,
    message: "Price of product must be a number greater than $0" }
    
end
