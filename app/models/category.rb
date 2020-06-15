class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true

  def self.product_by_category(category)
    target_category = Category.find_by(name: category).products
    retrun target_category.products
  end
end
