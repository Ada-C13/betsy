class AddOrderIdToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_reference :orderitems, :order, index: true
  end
end
