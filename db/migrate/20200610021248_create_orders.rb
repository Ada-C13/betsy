class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.integer :credit_card_num
      t.string :credit_card_exp
      t.integer :credit_card_cvv
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.datetime :time_submitted

      t.timestamps
    end
  end
end
