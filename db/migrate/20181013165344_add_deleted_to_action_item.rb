class AddDeletedToActionItem < ActiveRecord::Migration[5.2]
  def change
    add_column :action_items, :deleted, :boolean, default: false
  end
end
