class RemoveMerchantOrderReference < ActiveRecord::Migration[6.0]
  def change
    remove_reference :merchants, :order, index: true
  end
end
