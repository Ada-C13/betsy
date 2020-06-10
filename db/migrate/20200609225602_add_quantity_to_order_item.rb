class AddQuantityToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :qty, :integer
  end
end
