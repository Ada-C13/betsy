class RemoveOrderRelationToCustomer < ActiveRecord::Migration[6.0]
  def change
    remove_reference :orders, :customer, index: true
    add_column :orders, :customer_email, :string
  end
end
