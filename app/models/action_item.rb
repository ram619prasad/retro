# ActionItem Model
class ActionItem < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :column
  belongs_to :board

  # Validations
  validates_presence_of :description
  validates_length_of :description, in: 3..100
end
