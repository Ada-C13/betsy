class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true, uniqueness: { scope: :merchant }
  validates :price, presence: true, numericality: { only_float: true, greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :photo, presence: true 

  def destock(quantity) 
    if self.stock > quantity 
      self.stock -= quantity
    end
  end

  def restock(quantity)
    self.stock += quantity
  end

  def enough_stock?(quantity)
    if self.stock == 0
      errors.add(:stock, "#{self.name} out of stock.")
      return false
    elsif self.stock < quantity
      errors.add(:stock, "There are #{self.stock} #{self.name} in stock, select another quanity.")
      return false
    else
      return true
    end
  end

  def change_active
    self.active = !self.active
    self.save 
  end
end



