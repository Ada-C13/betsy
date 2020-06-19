class Order < ApplicationRecord
  has_many :order_items
  has_many :merchants, through: :products
  has_many :products, through: :order_items

  validates :card_number,
            presence: true,
            length: { is: 16 },
            format: { with: /[0-9]{16}/ },
            on: :update

  validates :card_expiration_date,
            presence: true,
            on: :update

  validates :card_cvv,
            presence: true,
            length: { is: 3 },
            format: { with: /[0-9]{3}/ },
            on: :update

  validates :address,
            presence: true,
            on: :update

  validates :city,
            presence: true,
            on: :update

  validates :zip_code,
            presence: true,
            format: { with: /[\d]{5}/ },
            on: :update

  validates :state,
            presence: true,
            on: :update

  validates :guest_name,
            presence: true,
            on: :update

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            on: :update

  validates :phone_num,
            presence: true,
            on: :update

  def total_price
    total = 0.0

    order_items.each do |item|
      total += (item.price * item.quantity)
    end

    total
  end

  def purchase_changes
    self.cart_status = false
    save
  end

  def self.cart_item_count(session)
    if session[:order_id] == nil || Order.find_by(id: session[:order_id]).nil?
      '0'
    else
      return Order.find_by(id: session[:order_id]).order_items.length
    end
  end
end
