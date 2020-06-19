class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.integer :uid
      t.string :email
      t.string :provider

      t.timestamps
    end
  end
end
