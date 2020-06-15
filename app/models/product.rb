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

  def decrease_quantity(quantity) 
    if self.stock > quantity 
      self.stock -= quantity
    end
  end

  def increase_quantity(quantity)
    self.stock += quantity
  end

  def zero_inventory
    return "OUT OF STOCK" if self.stock == 0
  end
end



