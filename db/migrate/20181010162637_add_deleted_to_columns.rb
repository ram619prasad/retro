class AddDeletedToColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :columns, :deleted, :boolean, default: false
  end
end
