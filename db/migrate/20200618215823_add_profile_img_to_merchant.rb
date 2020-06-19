class AddProfileImgToMerchant < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :profile_img, :string
  end
end
