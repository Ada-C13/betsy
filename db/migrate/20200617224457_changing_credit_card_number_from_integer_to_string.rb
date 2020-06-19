class ChangingCreditCardNumberFromIntegerToString < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :credit_card_number, :string
    change_column :orders, :credit_card_CVV, :string
    change_column :orders, :billing_zip_code, :string
    

  end
end
