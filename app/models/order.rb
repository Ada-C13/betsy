class Order < ApplicationRecord
  has_many   :orderitems, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled)
  validates :status, presence: true, inclusion: {in: VALID_STATUS}

  def process_payment
    # TODO implement payment
    return false unless self.status == "pending"
    return false if self.credit_card_num.nil? || self.credit_card_exp.empty? ||
                    self.credit_card_cvv.nil? || self.customer_email.empty?
    self.status = "paid"
    return self.save
  end

  def complete_order
    return false unless self.status == "paid"
    self.status = "complete"
    return self.save
  end

  def cancel_order
    self.status = "cancelled"
    return self.save
  end

end
