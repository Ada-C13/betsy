class OrderitemsUpdate < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :order_id, :bigint
    add_column :order_items, :complete, :boolean, default: false
    remove_column :order_items, :date
  end
end
