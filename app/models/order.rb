class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled)
  validates :status, presence: true, inclusion: {in: VALID_STATUS}
end
