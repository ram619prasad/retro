class ColumnSerializer < ActiveModel::Serializer
  attributes :id, :name, :hex_code, :deleted, :board

  def board
    ::BoardSerializer.new(object.board)
  end
end
