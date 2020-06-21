class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :email
      t.bigint  :merchant_id
      t.bigint  :provider

      t.timestamps
    end
  end
end
