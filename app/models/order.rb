require 'date'

class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  validates :status, presence: true    
  validates :name, presence: { message: "Name can't be blank"}, :on => :update
  validates :email, format: { with: /\A.+@.+\..{2,3}\z/, message: "E-mail address must be valid"}, :on => :update
  validates :address, presence: {message: "Address can't be blank"}, :on => :update
  validates :city, presence: { message: "City can't be blank"}, :on => :update
  validates :state, format: { with: /\A[a-zA-Z]{2}\z/, message: "State must be two letters in length"}, :on => :update
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "Zip code must be 5 digits" }, :on => :update
  validates :cc_num, format: { with: /\A\d{13,16}\z/, message: "Credit card number must be 13-16 numbers in length" }, :on => :update, 
  validates :cc_exp_month, format: {with: /\A\^(0?[1-9]|1[012])$\z/, message: "month must be between 1 and 12"}
  validates :cc_exp_year, format: { with: /\A\^\d{4}$\z/, message: "year must be 4 digits"} :on => :update
  validate :card_not_expired
  validates :cc_cvv, format: { with: /\A\d{3,4}\z/, message: "Credit card CVV must be 3-4 numbers in length" }, :on => :update  

  def total
    order_total = self.orderitems.sum do |orderitem|
      orderitem.total 
    end

    return order_total
  end

  def card_not_expired
    exp_month = DateTime.strptime(self.cc_exp_month, "%m").month
    exp_year = DateTime.strptime(self.cc_exp_year, "%Y").year

    if (exp_year >= Time.now.year) || (exp_year == Time.now.year && exp_month >= Time.now.month)
      errors.add(:exp_month, "card has expired")
    end
  end

  def check_status
    completed_count = 0
    cancelled_count = 0

    self.orderitems.each do |orderitem|
      if orderitem.complete == true
        completed_count += 1
      elsif orderitem.complete == nil
        cancelled_count += 1
      end
    end

    if completed_count == self.orderitems.length
      self.update(status: "complete")
    elsif cancelled_count == self.orderitems.length
      self.update(status: "cancelled")
    end
  end
end
