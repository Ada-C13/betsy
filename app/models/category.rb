class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: {
    message: "Category: %{value} already exists." 
  }

end
