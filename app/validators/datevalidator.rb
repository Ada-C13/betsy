class DateValidator < ActiveModel::Validator
  def validate(order)
    exp_date = Date.new(order.cc_exp_year, order.cc_exp_month)
    unless exp_date > Date.now
      order.errors[:exp_date] << 'The card must not be expired.'
    end
  end
end