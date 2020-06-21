class ChangeAvailableQuantityToStock < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :available_quantity, :stock
  end
end
