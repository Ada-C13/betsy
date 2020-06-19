class AddingCustomerInformationToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :email_address, :string
    add_column :orders, :mailing_address, :string
    add_column :orders, :name_on_credit_card, :string
    add_column :orders, :credit_card_number, :integer
    add_column :orders, :credit_card_expiration, :string
    add_column :orders, :credit_card_CVV, :integer
    add_column :orders, :billing_zip_code, :integer
  end
end
