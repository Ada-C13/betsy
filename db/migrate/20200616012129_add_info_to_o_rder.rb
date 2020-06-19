class AddInfoToORder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :street_address, :string
    add_column :orders, :city_state_zip, :string 
  end
end
