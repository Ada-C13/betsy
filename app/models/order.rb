class Order < ApplicationRecord
  VALID_STATUSES = ["pending", "paid", "shipped", "cancelled"] 
  has_many :order_items
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: VALID_STATUSES, message: "Status must be pending, paid, or shipped"} 
  def order_submitted?
    status == "paid" || status == "shipped"
  end
  with_options if: :order_submitted? do |submitted|
    submitted.validates :name, presence: true
    submitted.validates :email, presence: true, 
      format: { with: /[a-z0-9\+\-_\.]+@[a-z\d\-]+\.[a-z]+\z/, message: "email is not valid" }
    submitted.validates :address, presence: true
    submitted.validates :cc_last_four, presence: true, 
      format: { with: /\d{4}/, message: "cc_last_four is not valid" }
    submitted.validates :cc_exp_month, presence: true, 
      format: { with: /\d{2}/, message: "month exp must be in MM format" }
    submitted.validates :cc_exp_year, presence: true, 
      format: { with: /\d{4}/, message: "year exp must be in YYYY format" }
    submitted.validates :cc_cvv, presence: true, 
      format: { with: /\d{3,4}/, message: "invalid cvv" }
  end


  def cancel
    change_status("cancelled")
  end

  def clear_cart
    self.order_items.each do |order_item|
      order_item.destroy
    end
  end 

  def total_price
    total = 0.0
    self.order_items.each do |order_item|
      total += order_item.product.price
    end
    return total
    # format "$d.dd" method for order_item and order?
  end

  def find_order_item(product)
    self.order_items.each do |order_item|
      if order_item.product == product
        return order_item
      end
    end
    return nil
  end

  def submit_order
    change_status("paid")
  end

  private

  def change_status(new_status)
    if !VALID_STATUSES.include? new_status
      raise ArgumentError.new("status invalid")
    end
    self.status = new_status
    self.save
    self.order_items.each do |order_item|
      order_item.status = new_status
      order_item.save
    end
    return self.status
  end

  
end
