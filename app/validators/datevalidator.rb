class Datevalidator < ActiveModel::Validator
  def validate(order)
    if !order.cc_exp_year.empty? && !order.cc_exp_month.empty?
      exp_date = Date.new(order.cc_exp_year.to_i, order.cc_exp_month.to_i)
      unless exp_date > Date.today
        order.errors[:expiration] << 'The card must not be expired.'
      end
    else
      order.errors[:expiration] << 'Dates must be entered.'
    end
  end
end