class Review < ApplicationRecord
  belongs_to :product
  validates :text, presence: true, uniqueness: { scope: :product_id, message: "not a unique review for this product" }
  validates :rating, presence: true
end
