class AddDeletedToBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :deleted, :boolean, default: false
  end
end
