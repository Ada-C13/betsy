class RemoveMerchantIDfromOrder < ActiveRecord::Migration[6.0]
  def change
    remove_reference :orders, :merchant, index: true
  end
end
