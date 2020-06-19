class Review < ApplicationRecord
  belongs_to :product
  validates :rating, presence: true, numericality: { less_than_or_equal_to: 5, greater_than: 0, only_integer: true }
  validates :product_id, presence: true
end
