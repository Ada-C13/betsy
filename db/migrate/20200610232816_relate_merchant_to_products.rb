class RelateMerchantToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :merchant, foreign_key:true
  end
end
