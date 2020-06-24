class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :inventory
      t.string :photo_url
      t.string :category

      t.timestamps
    end
  end
end
