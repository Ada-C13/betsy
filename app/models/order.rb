class Order < ApplicationRecord
  has_many :order_items

  validates :buyer_name, presence: true
  validates :email_address, presence: true
  validates_format_of :email_address, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/  
  validates :mail_address, presence: true
  validates :zip_code, presence: true, numericality: true, length: {is: 5}
  validates :cc_num, presence: true, numericality: true
  validates :cc_exp, presence: true
  validates :order_items, presence: true

  def self.contains_merchant?(order_id, merch_id)
    # query checks to see if the order contains the merchant
    return !Order.where(:id => order_id).joins(:order_items => :product).where(:products => {:merchant_id => merch_id}).empty?
  end
end
