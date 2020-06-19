class RelateProductsAndOrdersToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_items, :product, index: true
    add_reference :order_items, :order, index: true
  end
end
