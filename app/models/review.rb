class Review < ApplicationRecord

  belongs_to :product

  validates :rating, :inclusion => { :in => 0..5, :message => " should be between 0 to 5" }

end
