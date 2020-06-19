  class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items
  has_many :reviews
  validates :name, :price, :inventory, :merchant_id, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  
  def average_rating
    return "No reviews yet" if reviews.length == 0

    average = reviews.average(:rating)
    return "#{average.round(2)} out of 5"
  end

  def reviews_length
    length = reviews.length

    return "#{length} review" if length == 1
    return "#{length} reviews"
  end

  def self.featured
    featured_products = []
    until featured_products.length == 3
      product = Product.where(active: true).sample
      if !featured_products.include?(product) && product.image != ""
        featured_products.push(product)
      end
    end
    
    return featured_products
  end 
end
