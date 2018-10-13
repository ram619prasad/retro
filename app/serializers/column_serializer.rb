class ColumnSerializer < ActiveModel::Serializer
  # attributes :id, :name, :hex_code, :deleted, :board

  # def board
  #   ::BoardSerializer.new(object.board)
  # end

  attributes :id, :name, :hex_code, :deleted

  belongs_to :board

  link(:self) { api_v1_column_path(object) }
  link(:board) { api_v1_board_path(object.board) }
end
