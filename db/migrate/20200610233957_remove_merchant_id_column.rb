class RemoveMerchantIdColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :merchants, :merchant_id
  end
end
