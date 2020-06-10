class Review < ApplicationRecord

  belongs_to :products

  validates :rating, :inclusion => { :in => 0..5, :message => " should be between 0 to 5" }

end
