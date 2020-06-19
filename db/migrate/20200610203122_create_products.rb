class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :stock
      t.boolean :active
      t.text :description
      t.string :photo

      t.timestamps
    end
  end
end
