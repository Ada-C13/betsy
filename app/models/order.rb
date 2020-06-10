class Order < ApplicationRecord
  has_many   :orderitems, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled)
  validates :status, presence: true, inclusion: {in: VALID_STATUS}
end
