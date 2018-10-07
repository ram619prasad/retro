class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :agenda, :deleted, :created_at, :updated_at, :user

  def user
      ::UserSerializer.new(object.user).attributes
  end

  link(:self) { api_v1_board_path(object) }
  link(:user) { profile_api_v1_user_path(object.user) }
end
