class RenameReviewsDescriptionToComment < ActiveRecord::Migration[6.0]
  def change
    rename_column :reviews, :description, :comment
  end
end
