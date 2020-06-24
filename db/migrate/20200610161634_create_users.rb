class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :emaiL_address
      t.string :username

      t.timestamps
    end
  end
end
