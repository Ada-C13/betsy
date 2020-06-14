class Review < ApplicationRecord
  belongs_to :product
  
  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: [1,2,3,4,5] , message: "You input is not a valid rating" }
  validates :feedback, presence: true
end
