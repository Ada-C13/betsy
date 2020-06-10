class RenameStatusColumnInProducts < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :status, :active
  end
end
