class Review < ApplicationRecord
  belongs_to :product
  validates :text, presence: true, uniqueness: true
  validates :rating, presence: true
end
