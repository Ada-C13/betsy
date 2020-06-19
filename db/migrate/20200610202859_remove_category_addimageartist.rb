class RemoveCategoryAddimageartist < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :category
    add_column :products, :image, :string
    add_column :products, :artist, :string
  end
end
