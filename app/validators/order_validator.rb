class OrderValidator < ActiveModel::Validator
  def validate(record)
    return true
  end
end