class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :card_number
      t.string :card_expiration_date
      t.string :card_cvv
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :guest_name
      t.string :email
      t.string :phone_num

      t.timestamps
    end
  end
end
