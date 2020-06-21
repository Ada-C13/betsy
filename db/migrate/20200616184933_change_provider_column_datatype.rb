class ChangeProviderColumnDatatype < ActiveRecord::Migration[6.0]
  def change
    change_column :merchants, :provider, :string #'string USING CAST(provider AS string)'
  end
end
