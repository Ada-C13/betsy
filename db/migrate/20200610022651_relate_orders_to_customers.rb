class RelateOrdersToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :customer, index: true
  end
end
