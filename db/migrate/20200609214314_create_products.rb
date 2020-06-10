class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :img_url
      t.string :description
      t.integer :qty

      t.timestamps
    end
  end
end
