class Review < ApplicationRecord
	belongs_to :product

	validates :title, presence: true
	validates :rating, 
		presence: true,
		:inclusion => 1..5
	validates :description, presence: true
end
