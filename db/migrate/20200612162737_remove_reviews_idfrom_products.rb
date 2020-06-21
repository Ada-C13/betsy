class RemoveReviewsIdfromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :products, :reviews, index: true
  end
end
