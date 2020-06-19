class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.integer :rating
      t.string :description

      t.timestamps
    end
  end
end
