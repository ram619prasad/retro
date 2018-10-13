class ActionItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :deleted

  belongs_to :column
  belongs_to :user
end
