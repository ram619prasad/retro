class AddCollaboratorIdsToBoard < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :collaborator_ids, :string, array: true, default: []
  end
end
