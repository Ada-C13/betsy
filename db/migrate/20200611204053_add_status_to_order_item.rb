class AddStatusToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :status, :string
    change_column_default :order_items, :status, "pending"
  end
end
