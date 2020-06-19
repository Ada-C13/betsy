class AddStatustoOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :fulfillment_status, :string, default: "pending"
  end
end