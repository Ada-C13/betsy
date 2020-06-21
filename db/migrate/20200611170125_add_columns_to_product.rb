class AddColumnsToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :retired, :boolean 
  end
end
