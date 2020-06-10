class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :photo
      t.integer :stock
      t.boolean :active

      t.timestamps
    end
  end
end
