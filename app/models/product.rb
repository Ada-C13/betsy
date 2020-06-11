class Product < ApplicationRecord
  has_and_belongs_to_many :categories

  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true 
  # validates :title, uniqueness: { case_sensitive: false}

  validates :price, presence: true

  # def self.get_active_products
  #   return Product.where(active: true)
  # end

  # def deactivate_product(product_id)
  #   product = Product.find_by(id: product_id)
  #   if product
  #     if product.active == true 
  #       product.active = false 
  #       if product.save
  #         flash[:success] = "Successfully deactivated #{product.title}"
  #       end
  #     end
  #   else
  #     flash[:error] = "Product not found"
  #   end
  # end
end
