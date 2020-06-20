class SetDefaultPhotoOfProduct < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :photo, "https://i.imgur.com/WSHmeuf.jpg"
  end
end
