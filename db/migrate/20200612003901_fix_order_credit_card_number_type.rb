class FixOrderCreditCardNumberType < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :credit_card_num, :bigint
  end
end
