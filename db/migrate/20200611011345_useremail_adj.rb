class UseremailAdj < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :emaiL_address, :email_address
  end
end
