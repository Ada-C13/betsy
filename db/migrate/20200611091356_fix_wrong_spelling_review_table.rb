class FixWrongSpellingReviewTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :reveiws, :reviews
  end
end
