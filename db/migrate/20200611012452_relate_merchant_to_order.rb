class RelateMerchantToOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :merchants, :order, index: true
  end
end
