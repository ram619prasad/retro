class AddUserReferencesToColumn < ActiveRecord::Migration[5.2]
  def change
    add_reference :columns, :user, foreign_key: true
  end
end
