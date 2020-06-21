class RemoveProductsIdfromCategories < ActiveRecord::Migration[6.0]
  def change
    remove_reference :categories, :products, index: true
  end
end
