class Board < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :columns, dependent: :destroy
  has_many :action_items, through: :columns, dependent: :destroy

  # Only allows user to get 50 boards if the per_page param is more than 50
  max_paginates_per 50
  paginates_per 20

  # Scopes
  default_scope {where('deleted is not true')}
  scope :active, -> { where(deleted: false)}
  scope :deleted, -> { unscoped.where(deleted: true) }

  # Validations
  validates_presence_of :title, :user_id
  validates_uniqueness_of :title, scope: :user_id
end
