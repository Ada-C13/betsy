class RelateReviewsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :product, foreign_key: true 
  end
end
