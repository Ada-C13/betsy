class AddStatusToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :cart_status, :boolean, default: true
  end
end
