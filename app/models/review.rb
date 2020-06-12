class Review < ApplicationRecord
  belongs_to :product
  
  validates :rating, presence: true #, numericality: { only_integer: true }, inclusion: { in: %w(1 2 3 4 5), message: "%{value} is not a valid rating" }
  validates :feedback, presence: true
end
