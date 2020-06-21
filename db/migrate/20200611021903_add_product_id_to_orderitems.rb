class AddProductIdToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_reference :orderitems, :product, index: true
  end
end
