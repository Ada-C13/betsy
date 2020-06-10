class CreateReveiws < ActiveRecord::Migration[6.0]
  def change
    create_table :reveiws do |t|
      t.integer :rating
      t.string :feedback

      t.timestamps
    end
  end
end
