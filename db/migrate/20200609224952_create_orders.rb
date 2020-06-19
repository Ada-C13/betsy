class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :mailing_address
      t.integer :cc_number
      t.date :cc_exp
      t.datetime :purchase_date
      t.string :status

      t.timestamps
    end
  end
end
