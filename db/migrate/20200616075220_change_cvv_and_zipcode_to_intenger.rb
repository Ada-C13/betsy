class ChangeCvvAndZipcodeToIntenger < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :zipcode, 'integer USING CAST(zipcode AS integer)'
    change_column :orders, :cvv, 'integer USING CAST(cvv AS integer)'
  end
end