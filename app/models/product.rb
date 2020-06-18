class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :reviews
  has_many :order_items, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :merchant_id, 
    message: "%{value} has already been taken." }
  validates :price, presence: true, numericality: { greater_than: 0,
    message: "must be a number greater than $0" }
  validates :stock, presence: true, numericality: { greater_than: 0 }

  def self.filter_products(categories, merchants)
    products = []
    filters = []

    categories.each do |c|
      if Category.exists?(c)
        category = Category.find(c)
        products << category.products.where(active: true)
        filters << category.name
      end
    end

    merchants.each do |m|
      if Merchant.exists?(m)
        products << Product.where(merchant: m, active: true)
        filters << Merchant.find(m).username
      end
    end

    return {products: products.flatten.uniq, filters: filters}
  end

  def self.active_products
    Product.all.where(active: true)
  end
end
