class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|
      t.integer :guest_id

      t.timestamps
    end
  end
end
