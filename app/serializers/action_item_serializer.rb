class ActionItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :deleted, :board_id, :column_id, :user_id

  link(:self) { api_v1_action_item_path(object) }
  link(:board) { api_v1_board_path(object.board) }
  link(:column) { api_v1_column_path(object.column) }
  link(:user) { profile_api_v1_user_path(object.user) }
end
