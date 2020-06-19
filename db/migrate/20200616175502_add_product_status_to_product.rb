class AddProductStatusToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :product_status, :string
  end
end
