class Review < ApplicationRecord

  belongs_to :product

  validates :rating, :numericality => { :in => 0..5, :message => " should be between 0 to 5" }
  #validates  :rating, :numericality: { greater_than: 0, less_than_or_equal_to: 5 }
end
