class SetDefaultValueOfActiveInProduct < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :active, true
  end
end
