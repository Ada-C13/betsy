class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.integer :uid
      t.string :provider
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
