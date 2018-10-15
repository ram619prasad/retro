class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :agenda, :deleted, :created_at, :updated_at, :user, :columns

  # has_many :columns

  def user
    ::UserSerializer.new(object.user).attributes
  end

  def columns
    object.columns.each { |col| ::ColumnSerializer.new(col) }
  end

  link(:self) { api_v1_board_path(object) }
  link(:user) { profile_api_v1_user_path(object.user) }
end
