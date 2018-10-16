# frozen_string_literal: true

# Column Json Serializer
class ColumnSerializer < ActiveModel::Serializer
  attributes :id, :name, :hex_code, :deleted

  belongs_to :board

  link(:self) { api_v1_column_path(object) }
  link(:board) { api_v1_board_path(object.board) }
end
