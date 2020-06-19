class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  has_and_belongs_to_many :categories
  has_many :orders, through: :order_items
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  validates :qty, presence: true, numericality: { only_integer: true, :greater_than_or_equal_to => 0  }
#TODO chelsea added :greater_than_or_equal_to => 0  need to test
  def average_rating
    if self.reviews.length == 0
      return 0
    else
      (self.reviews.sum { |review| review.rating.to_f } / self.reviews.length).round(2)
    end
  end

  protected 
  
  def self.available?(product_id, order_item_qty)
    product = Product.find_by(id: product_id)
    return product.qty >= order_item_qty.to_i
  end 

  def self.update_quantity(product_id, qty)
    product = Product.find_by(id: product_id)
    
    product.update!(qty: (product.qty -= qty.to_i))
    
  end

end
