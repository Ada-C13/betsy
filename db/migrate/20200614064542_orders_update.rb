class OrdersUpdate < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zipcode, :string
    add_column :orders, :email_address, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :cc_exp_month, :string
    add_column :orders, :cc_exp_year, :string
    add_column :orders, :cc_cvv, :string
    add_column :orders, :order_date, :datetime
  end
end
