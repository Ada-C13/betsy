class AddAttributesToReview < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :rating, :integer
    add_column :reviews, :text, :string
  end
end
