class DropCategorietable < ActiveRecord::Migration[6.0]
  def change
    drop_table :products_categories_joins
  end
end
