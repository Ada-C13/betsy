class AddReferenceOrderToMerchants < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :merchant, index: true
  end
end
