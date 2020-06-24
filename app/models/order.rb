require 'date'
require_relative '../validators/order_validator'

class Order < ApplicationRecord
  include ActiveModel::Validations
  validates_with OrderValidator

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  validates :status, presence: true    
  validates :name, presence: {message: "Name can't be blank"}, :on => :update
  validates :email_address, format: {with: /\A.+@.+\..{2,3}\z/, message: "E-mail address must be valid"}, :on => :update
  validates :address, presence: {message: "Address can't be blank"}, :on => :update
  validates :city, presence: {message: "City can't be blank"}, :on => :update
  validates :state, format: {with: /\A[a-zA-Z]{2}\z/, message: "State must be two letters in length"}, :on => :update
  validates :zipcode, format: {with: /\A\d{5}\z/, message: "Zip code must be 5 digits"}, :on => :update
  validates :cc_cvv, format: {with: /\A\d{3,4}\z/, message: "Credit card CVV must be 3-4 numbers in length"}, :on => :update 

  def total
    return 0 if self.order_items.length == 0
    
    order_total = 0
    
    self.order_items.each do |item|
      p = Product.find_by(id: item["product_id"])
      order_total += (p.price * item.quantity)
    end

    return order_total
  end

  def self.get_items(merchant_products)
    merchant_products.each do |product|
      return product.name
    end
  end

  def mark_shipped
    self.update!(status: 'shipped')
  end
end
