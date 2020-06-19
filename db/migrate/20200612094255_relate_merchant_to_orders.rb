class RelateMerchantToOrders < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :merchant, foreign_key: true
  end
end
