class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :title, :created_at, :updated_at
end
