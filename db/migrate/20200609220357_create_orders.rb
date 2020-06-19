class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :address
      t.integer :credit_card
      t.date :credit_card_exp

      t.timestamps
    end
  end
end
