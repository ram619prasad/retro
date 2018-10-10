class AddDefaultValueToHexCode < ActiveRecord::Migration[5.2]
  def change
    change_column :columns, :hex_code, :string, default: '#FFFFFF'
  end
end
