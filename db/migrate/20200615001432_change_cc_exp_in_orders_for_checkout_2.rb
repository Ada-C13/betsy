class ChangeCcExpInOrdersForCheckout2 < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :cc_exp_month, :string
    add_column :orders, :cc_exp_year, :string
    remove_column :orders, :cc_exp
  end
end
