class AddReviewerToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :reviewer, :string
  end
end
