class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.string :photo_url
      t.string :description
      t.integer :stock

      t.timestamps
    end
  end
end
