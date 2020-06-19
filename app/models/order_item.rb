class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order, optional: true
  validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  def self.display_items(order_items)  
    unique_items = {}
    order_items.each do |item|
      product = Product.find_by(id: item["product_id"])
      unique_items[product] = item["qty"]
    end 
    return unique_items 
  end 

  def self.remove_from_cart(session, product_id)
    updated_cart =  []
    session.each do |item|
      if product_id.to_i != item["product_id"].to_i
        updated_cart << item 
      end 
    end
    return updated_cart
  end 

  def self.current_edit(product_id, session) 
    session.each do |item|
      if item["product_id"] == product_id 
        return item["qty"].to_s
      end 
    end 
    return "0"
  end 
     
end


