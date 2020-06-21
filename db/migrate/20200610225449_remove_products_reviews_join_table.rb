class RemoveProductsReviewsJoinTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :products_reviews
  end
end
