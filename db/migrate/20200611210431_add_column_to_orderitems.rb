class AddColumnToOrderitems < ActiveRecord::Migration[6.0]
  def change
    change_column :orderitems, :quantity, 'bigint USING CAST(quantity AS bigint)'
  end
end
