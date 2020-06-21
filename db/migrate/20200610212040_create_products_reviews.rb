class CreateProductsReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :products_reviews do |t|
      t.belongs_to :product, index: true
      t.belongs_to :review, index: true
    end
  end
end
