class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :title, :boards, :created_at, :updated_at

  link(:self) { profile_api_v1_user_path(object) }

  def boards
    object.boards.size
  end
end
