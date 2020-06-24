class AddDetailsUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :species, :string 
    add_column :users, :personality, :string 
    add_column :users, :phrase, :string
  end
end
