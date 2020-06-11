class Order < ApplicationRecord
  has_many   :order_items, dependent: :destroy

  VALID_STATUS = %w(pending paid complete cancelled) # ask the instructor when does it go from paid to complete
  validates :status, presence: true, inclusion: {in: VALID_STATUS}

  def process_payment!
    # TODO implement payment
    return false if self.status != "pending"
    return false if self.credit_card_num.nil? || self.credit_card_exp.empty? ||
                    self.credit_card_cvv.nil? || self.customer_email.empty?
    self.status = "paid"
    return self.save
  end

  def complete_order!
    return false if self.status != "paid"
    self.status = "complete"
    return self.save
  end

  def cancel_order!
    return false if self.status != "paid" # add a test here!
    self.status = "cancelled"
    return self.save
  end
  # ability to clear the cart, removes the items, erase my cart, the order is a session, always one and only one 
  # add a total_cost method that returns the total cost for the order, loop thru the order items, find the price of each, multiply and add, and retiurn
end
