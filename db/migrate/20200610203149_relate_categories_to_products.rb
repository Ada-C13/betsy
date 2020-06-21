class RelateCategoriesToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :categories, :products, index: true
  end
end
