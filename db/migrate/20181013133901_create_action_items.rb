class CreateActionItems < ActiveRecord::Migration[5.2]
  def change
    create_table :action_items do |t|
      t.text :description
      t.references :user, foreign_key: true
      t.references :column, foreign_key: true
      t.references :board, foreign_key: true

      t.timestamps
    end
  end
end
