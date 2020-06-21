class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :product_name
      t.string :description
      t.float :price
      t.string :photo_url
      t.bigint :available_quantity

      t.timestamps
    end
  end
end
