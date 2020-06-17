class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true

  # def self.product_by_category(category)
  #   each_category = Category.find_by(name: category)
  #   return each_category.products
  # end
end
