class ChangeCcNumberDataType < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :cc_number, :bigint
  end
end
