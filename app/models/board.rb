class Board < ApplicationRecord
  # Associations
  belongs_to :user

  # Scopes
  scope :active, -> { where(deleted: false)}
  scope :deleted, -> { where(deleted: true)}

  # Validations
  validates_presence_of :title, :user_id
  validates_uniqueness_of :title, scope: :user_id
end
