class AddPhotoUrlToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :photo_url, :string, default: "https://f1.pngfuel.com/png/584/952/34/black-and-white-flower-black-white-m-leaf-plant-stem-silhouette-computer-line-plants-png-clip-art.png"
  end
end
