class AddColumnsToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :shipped, :boolean
  end
end
