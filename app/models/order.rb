class Order < ApplicationRecord

  has_many :order_items,dependent: :destroy
  
    validates_presence_of :customer_name, :address, :email, :last_four_cc, :exp_date, :cvv, :zip, on: :update
  
    validates :last_four_cc, length:{is: 4}, on: :update
    validates :cvv, length:{is: 3},on: :update
    validates :zip, length:{is: 5}, on: :update

  has_many :order_items, dependent: :destroy

  def subtotal 
    total = 0 
    self.order_items.map { |order_item| total += order_item.total_price_qty  }
    return total.round(2)
  end 

  def taxes 
    subtotal = self.subtotal()
    taxes = subtotal * 0.10
    return taxes.round(2) 
  end 

  def purchase_total 
    return total = (self.subtotal() + self.taxes()).round(2)
  end 

  def decrement_stock
    self.order_items.each do |item|
      item.product.stock -= item.quantity 
      item.product.save 
    end
  end 

end
