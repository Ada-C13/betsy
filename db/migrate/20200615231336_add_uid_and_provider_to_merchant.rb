class AddUidAndProviderToMerchant < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :uid, :integer
  end
end
