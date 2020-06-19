class ChangeFieldTypesInOrdersForCheckout < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :cc_cvv, :string
  end
end
