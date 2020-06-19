class AddMerchantToOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :merchants, :order, foreign_key: true
  end
end
