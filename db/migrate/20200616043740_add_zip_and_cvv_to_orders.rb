class AddZipAndCvvToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :zipcode, :string
    add_column :orders, :cvv, :string
  end
end
