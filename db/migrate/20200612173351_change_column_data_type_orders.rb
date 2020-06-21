class ChangeColumnDataTypeOrders < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :cc_exp, :string
  end
end
