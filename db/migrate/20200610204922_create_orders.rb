class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :cc_last_four
      t.date :cc_exp
      t.integer :cc_cvv
      t.string :status

      t.timestamps
    end
  end
end
