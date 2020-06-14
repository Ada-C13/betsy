class Review < ApplicationRecord
  belongs_to :product
  validates :text, presence: true, uniqueness: { scope: :product_id, message: "not a unique review for this product" }
  validates :rating, presence: true, :inclusion => { :in => 0..5 }
end
