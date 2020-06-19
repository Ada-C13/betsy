class AddColumnToProductTable < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :name, :string
    add_column :products, :price, :float
    add_column :products, :description, :string
    add_column :products, :photo_url, :string
    add_column :products, :stock, :integer
  end
end
