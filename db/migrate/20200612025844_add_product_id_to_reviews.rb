class AddProductIdToReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :product, foregin_key: true
  end
end