class RelateProductsToReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :reviews, index: true
  end
end
