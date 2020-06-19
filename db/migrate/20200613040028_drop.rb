class Drop < ActiveRecord::Migration[6.0]
  def up
    drop_table :products_categories_joins
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
