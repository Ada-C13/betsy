class RemoveCustomer < ActiveRecord::Migration[6.0]
  def change
    drop_table :customers, if_exists: true
  end
end
