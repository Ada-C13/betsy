class DeleteCart < ActiveRecord::Migration[6.0]
  def change
    drop_table :carts
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
