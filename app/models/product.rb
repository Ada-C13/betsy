class Product < ApplicationRecord
  has_and_belongs_to_many :categories

  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true 
  validates :title, uniqueness: { case_sensitive: false}

  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  validates :stock, presence: true
  validates :stock, numericality: { greater_than: -1 }

  # Regex was taken from stackoverflow: 
  # https://stackoverflow.com/questions/1805761/how-to-check-if-a-url-is-valid 
  # https://stackoverflow.com/questions/2650549/when-should-i-use-a-in-a-regex
  # and updated with \A and \z on the sides
  validates :photo_url, presence: true, format: { 
    with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix }
end
