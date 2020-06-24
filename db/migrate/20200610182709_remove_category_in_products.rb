class RemoveCategoryInProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :category
  end
end

# reference: https://stackoverflow.com/questions/2831059/how-to-drop-columns-using-rails-migration